# frozen_string_literal: true

require_relative './balance'
require_relative './ticker'

require 'net/http'
require 'openssl'
require 'json'
require 'uri'
require 'time'

BASE_URL = 'https://api.bitflyer.com'

class APIClient
  attr_reader :key, :secret

  def initialize(key, secret)
    @key = key
    @secret = secret
  end

  def header(method, endpoint, body = '')
    timestamp = Time.now.to_i.to_s
    body = JSON.generate(body) unless body.empty?
    text = timestamp + method + endpoint + body
    sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, text) # secretkeyを用いて、textのHMACを計算する
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
end
