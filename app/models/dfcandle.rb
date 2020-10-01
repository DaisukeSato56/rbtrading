# frozen_string_literal: true

require_relative '../../config/config'

class DataFrameCandle
  attr_reader :product_code, :duration, :candle_cls, :candles

  def initialize(product_code = ConfigList.new.product_code, duration = ConfigList.new.trade_duration)
    @product_code = product_code
    @duration = duration
    @candle_cls = factory_candle_class(product_code, duration)
    @candles = []
  end

  def value
    {
      'product_code': product_code,
      'duration': duration,
      'candles': candles.map(&:value)

    }
  end
end
