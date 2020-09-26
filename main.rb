# frozen_string_literal: true

require 'net/http'
require 'uri'
require './config/init.rb'
require './config/config'
require './bitflyer/bitflyer'

def main
  # conf = ConfigList.new
  # apiClient = BitflyerAPIClient.new(conf.api_key, conf.api_secret)
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
  puts BtcJpy_5sCandle.count
end

main if __FILE__ == $PROGRAM_NAME
