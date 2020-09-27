# frozen_string_literal: true

require_relative '../../constants.rb'
require_relative '../../config/init.rb'

class Candle
  def self.create_candle_with_duration(product_code, duration, ticker)
    cls = factory_candle_class(product_code, duration)
    ticker_time = ticker.truncate_date_time(duration)
    current_candle = cls.find_by(time: ticker_time)
    price = ticker.mid_price
    if current_candle.nil?
      cls.create(time: ticker_time, high: price, low: price, open: price, close: price, volume: ticker.volume)
      return true
    end

    if current_candle.high <= price
      current_candle.high = price
    elsif current_candle.low >= price
      current_candle.low = price
    end
    current_candle.volume += ticker.volume
    current_candle.close = price
    current_candle.save
    false
  end

  def self.factory_candle_class(product_code, duration)
    if product_code == PRODUCT_CODE_BTC_JPY
      return BtcJpy_5sCandle if duration == DURATION_5S
      return BtcJpy_1mCandle if duration == DURATION_1M
      return BtcJpy_1hCandle if duration == DURATION_1H
    end
  end
end
