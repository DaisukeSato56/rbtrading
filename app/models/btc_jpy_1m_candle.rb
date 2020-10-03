# frozen_string_literal: true

require_relative './candle.rb'

class BtcJpy_1mCandle < ActiveRecord::Base
  include Candle
end
