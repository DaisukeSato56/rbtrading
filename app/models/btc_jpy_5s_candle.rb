# frozen_string_literal: true

require_relative './candle.rb'

class BtcJpy_5sCandle < ActiveRecord::Base
  include Candle
end
