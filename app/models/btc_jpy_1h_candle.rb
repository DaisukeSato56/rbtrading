# frozen_string_literal: true

require_relative './candle.rb'

class BtcJpy_1hCandle < ActiveRecord::Base
  include Candle
end
