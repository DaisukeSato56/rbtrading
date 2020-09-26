# frozen_string_literal: true

require './config/config'
require './bitflyer/bitflyer'
require 'net/http'
require 'uri'

def main
  conf = ConfigList.new
  apiClient = BitflyerAPIClient.new(conf.api_key, conf.api_secret)
  queue = Queue.new

  t = Thread.new do
    loop do
      apiClient.real_time_ticker('BTC_JPY', queue)
    end
  end

  loop do
    n = queue.pop
    puts n.object_id
  end
end

main if __FILE__ == $PROGRAM_NAME
