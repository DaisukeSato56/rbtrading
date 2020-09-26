# frozen_string_literal: true

require_relative './balance'
require_relative './ticker'

require 'net/http'
require 'openssl'
require 'json'
require 'uri'
require 'time'
require 'websocket-client-simple'
require 'securerandom'
require 'rubygems'

BASE_URL = 'https://api.bitflyer.com'
JSONRPC_ID_AUTH = 1

class BitflyerAPIClient
  attr_reader :key, :secret

  def initialize(key, secret)
    @key = key
    @secret = secret
  end

  def header(method, endpoint, body = '')
    timestamp = Time.now.to_i.to_s
    body = JSON.generate(body) unless body.empty?
    text = timestamp + method + endpoint + body
    sign = OpenSSL::HMAC.hexdigest('sha256', secret, text) # secretkeyを用いて、textのHMACを計算する
    headers = {
      'ACCESS-KEY': key,
      'ACCESS-TIMESTAMP': timestamp,
      'ACCESS-SIGN': sign
    }
    headers['Content-Type'] = 'application/json' if method == 'POST'
    headers
  end

  def do_request(method, uri, body = '')
    options = Net::HTTP::Get.new(uri.request_uri)
    options.initialize_http_header(header(method, uri.path))
    options.body = body unless body.nil?

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = uri.scheme === 'https'
    response = https.request(options)
    JSON.parse(response.body)
  end

  def balance
    uri = URI.parse(BASE_URL)
    uri.path = '/v1/me/getbalance'
    resp = do_request('GET', uri)
    balance = resp.map { |r| Balance.new(r['currency_code'], r['amount'], r['avaliable']) }
    balance
  end

  def ticker(product_code)
    uri = URI.parse(BASE_URL)
    uri.path = '/v1/ticker'
    uri.query = "product_code=#{product_code}"
    resp = do_request('GET', uri)
    Ticker.new(resp['product_code'], Time.parse(resp['timestamp']), resp['tick_id'], resp['best_bid'], resp['best_ask'], resp['best_bid_size'], resp['best_ask_size'], resp['total_bid_depth'], resp['total_ask_depth'], resp['ltp'], resp['volume'], resp['volume_by_product'])
  end

  def real_time_ticker(product_code, queue)
    publicChannels = ["lightning_ticker_#{product_code}"]
    privateChannels = ['child_order_events']
    ws = WebSocket::Client::Simple.connect 'wss://ws.lightstream.bitflyer.com/json-rpc'
    ws.on :open do
      publicChannels.each do |channel|
        json = JSON.generate({ method: :subscribe, params: { channel: channel }, id: nil })
        ws.send(json)
      end

      now = Time.now.strftime('%s%L')
      nonce = SecureRandom.hex(16)
      sign = OpenSSL::HMAC.hexdigest('sha256', secret, now + nonce)

      ws.send(JSON.generate({
                              method: :auth,
                              params: {
                                api_key: key,
                                timestamp: now.to_i,
                                nonce: nonce,
                                signature: sign
                              },
                              id: JSONRPC_ID_AUTH
                            }))
    end

    ws.on :message do |msg|
      data = JSON.parse(msg.data)

      if data['id'] == JSONRPC_ID_AUTH
        if !data['error'].nil?
          puts 'auth error: ' + data['error']['message']
          exit
        else
          privateChannels.each do |channel|
            json = JSON.generate({ method: :subscribe, params: { channel: channel }, id: nil })
            ws.send(json)
          end
        end
      end

      ticker_data = data['params']['message'] if data['method'] == 'channelMessage'
      ticker = Ticker.new(ticker_data['product_code'], Time.parse(ticker_data['timestamp']), ticker_data['tick_id'], ticker_data['best_bid'], ticker_data['best_ask'], ticker_data['best_bid_size'], ticker_data['best_ask_size'], ticker_data['total_bid_depth'], ticker_data['total_ask_depth'], ticker_data['ltp'], ticker_data['volume'], ticker_data['volume_by_product'])
      queue.push(ticker)
    end

    ws.on :close do |e|
      p e
      exit 1
    end

    ws.on :error do |e|
      # p e
    end
  end
end
