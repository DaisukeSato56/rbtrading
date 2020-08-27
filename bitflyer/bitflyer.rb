# frozen_string_literal: true

require 'net/http'
require 'openssl'
require 'json'
require 'uri'

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
    puts balance
    balance
  end
end

class Balance
  def initialize(current_code, amount, avaliable)
    @current_code = current_code
    @amount = amount
    @avaliable = avaliable
  end
end
