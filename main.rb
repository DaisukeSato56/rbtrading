# frozen_string_literal: true

require './config/config'
require './bitflyer/bitflyer'
require 'net/http'
require 'uri'

def main
  conf = ConfigList.new
  b = APIClient.new(conf.api_key, conf.api_secret)
  ticker = b.ticker('BTC_USD')
  puts ticker.mid_price
  puts ticker.time
  puts ticker.truncate_date_time('1h')
end

main if __FILE__ == $PROGRAM_NAME
