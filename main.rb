# frozen_string_literal: true

require 'net/http'
require 'uri'
require './config/init.rb'
require './config/config'
require './bitflyer/bitflyer'
require './app/controllers/streamdata.rb'
require './app/controllers/webserver.rb'

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

  Webserver.run! host: 'localhost', port: 8080
end

main if __FILE__ == $PROGRAM_NAME
