# frozen_string_literal: true

class Ticker
  attr_reader :product_code, :timestamp, :tick_id, :best_bid, :best_ask, :best_bid_size, :best_ask_size, :total_bid_depth, :total_ask_depth, :ltp, :volume, :volume_by_product

  def initialize(product_code, timestamp, tick_id, best_bid, best_ask, best_bid_size, best_ask_size, total_bid_depth, total_ask_depth, ltp, volume, volume_by_product)
    @product_code = product_code
    @timestamp = timestamp
    @tick_id = tick_id
    @best_bid = best_bid
    @best_ask = best_ask
    @best_bid_size = best_bid_size
    @best_ask_size = best_ask_size
    @total_bid_depth = total_bid_depth
    @total_ask_depth = total_ask_depth
    @ltp = ltp
    @volume = volume
    @volume_by_product = volume_by_product
  end

  def mid_price
    (best_bid + best_ask) / 2
  end

  def date_time
    timestamp.rfc3339
  end

  def time
    timestamp.getutc
  end

  def truncate_date_time(duration)
    ticker_time = time
    if duration == '5s'
      new_sec = time.sec.floor / 5 * 5
      ticker_time = Time.new(
        time.year, time.month, time.day, time.hour, time.min, new_sec
      )
      time_format = '%Y-%m-%d %H:%M:%S'
    elsif duration == '1m'
      time_format = '%Y-%m-%d %H:%M'
    elsif duration == '1h'
      time_format = '%Y-%m-%d %H'
    else
      raise 'action=truncate_date_time error=no_datetime_format'
    end

    str_date = ticker_time.strftime(time_format)
    Time.strptime(str_date, time_format)
  end
end
