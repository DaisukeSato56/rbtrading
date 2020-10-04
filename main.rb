# frozen_string_literal: true

require 'net/http'
require 'uri'
require './config/init.rb'
require './config/config'
require './bitflyer/bitflyer'
require './app/contollers/streamdata.rb'

def main
  # stream_thread = Thread.new do
  #   loop do
  #     begin
  #       StreamData.new.stream_ingestion_data
  #     rescue StandardError
  #       # TODO: threadを立て直さないとエラーが起きる
  #       puts 'error of websocket connection'
  #       sleep 60
  #     end
  #   end
  # end

  # stream_thread.join

  df = DataFrameCandle.new
  df.set_all_candles
  p df.value
end

main if __FILE__ == $PROGRAM_NAME
