# frozen_string_literal: true

require './config/config'
require './bitflyer/bitflyer'
require 'net/http'
require 'uri'

def main
  conf = ConfigList.new
  b = BitflyerAPIClient.new(conf.api_key, conf.api_secret)
  b.real_time_ticker('BTC_JPY')
end

main if __FILE__ == $PROGRAM_NAME
