# frozen_string_literal: true

require_relative '../../constants.rb'

class Candle
  def self.create_candle_with_duration(product_code, duration, _ticker)
    cls = factory_candle_class(product_code, duration)
  end

  def self.factory_candle_class(product_code, duration)
    if product_code == PRODUCT_CODE_BTC_JPY
      return BtcJpy_5sCandle if duration == DURATION_5S
      return BtcJpy_1mCandle if duration == DURATION_1M
      return BtcJpy_1hCandle if duration == DURATION_1H
    end
  end
end
