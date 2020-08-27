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
end
