# frozen_string_literal: true

require 'net/http'
require 'uri'
require './config/init.rb'
require './config/config'
require './bitflyer/bitflyer'
require './app/contollers/streamdata.rb'

def main
  stream_thread = Thread.new do
    loop do
      begin
        StreamData.new.stream_ingestion_data
      rescue StandardError
        # TODO: threadを立て直さないとエラーが起きる
        puts 'error of websocket connection'
        sleep 60
      end
    end
  end

  stream_thread.join

  # queue = Queue.new

  # t = Thread.new do
  #   loop do
  #     apiClient.real_time_ticker('BTC_JPY', queue)
  #   end
  # end

  # loop do
  #   n = queue.pop
  #   puts n.object_id
  # end
end

main if __FILE__ == $PROGRAM_NAME
