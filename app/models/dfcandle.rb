# frozen_string_literal: true

require_relative '../../config/config'
require_relative './candle.rb'

class DataFrameCandle
  attr_reader :product_code, :duration, :candle_cls
  attr_accessor :candles

  def initialize(product_code = ConfigList.new.product_code, duration = ConfigList.new.trade_duration)
    @product_code = product_code
    @duration = duration
    @candle_cls = Candle.factory_candle_class(product_code, duration)
    @candles = []
  end

  def set_all_candles(limit = 1000)
    @candles = candle_cls.all.limit(limit)
  end

  def value
    {
      'product_code': product_code,
      'duration': duration,
      'candles': candles.map(&:value)
    }
  end
end
