# frozen_string_literal: true

require 'net/http'
require 'openssl'
require 'json'
require 'uri'

BASE_URL = 'https://api.bitflyer.com/v1/'

class APIClient
  attr_reader :key, :secret

  def initialize(key, secret)
    @key = key
    @secret = secret
  end

  def header(method, endpoint, body)
    timestamp = Time.now.strftime
    body = JSON.generate(body)
    text = timestamp + method + endpoint + body
    sign = OpenSSL::HMAC.hexdigest('sha256', secret, text) # secretkeyを用いて、textのHMACを計算する
    headers = {
      'ACCESS-KEY': key,
      'ACCESS-TIMESTAMP': timestamp,
      'ACCESS-SIGN': sign,
      'Content-Type': 'application/json'
    }
    headers
  end

  def do_request(_method, url_path, _query, _data)
    base_url = URI.parse(BASE_URL)
    api_url = URI.parse(url_path)
    endpoint = URI.join(base_url, api_url)
  end
end
