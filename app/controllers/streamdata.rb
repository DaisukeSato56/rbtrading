# frozen_string_literal: true

require_relative '../../config/init.rb'
require_relative '../../constants.rb'
require_relative '../../config/config'
require_relative '../../bitflyer/bitflyer'
require_relative '../../constants.rb'

class StreamData
  def initialize
    @trade = lambda { |ticker|
      DURATIONS.each do |duration|
        is_created = Candle.create_candle_with_duration(ticker.product_code, duration, ticker)
        puts is_created
      end
    }
  end

  def stream_ingestion_data
    conf = ConfigList.new
    apiClient = BitflyerAPIClient.new(conf.api_key, conf.api_secret)
    apiClient.real_time_ticker('BTC_JPY', @trade)
  end
end
