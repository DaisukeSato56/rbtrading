# frozen_string_literal: true

require 'net/http'
require 'uri'
require './config/init.rb'
require './config/config'
require './bitflyer/bitflyer'

def main
  conf = ConfigList.new
  apiClient = BitflyerAPIClient.new(conf.api_key, conf.api_secret)

  ticker = apiClient.ticker(conf.product_code)
  Candle.create_candle_with_duration(conf.product_code, '1m', ticker)
  # queue = Queue.new

  # t = Thread.new do
  #   loop do
  #     apiClient.real_time_ticker('BTC_JPY', queue)
  #   end
  # end

  # loop do
  #   n = queue.pop
  #   puts n.object_id
  # end
end

main if __FILE__ == $PROGRAM_NAME
