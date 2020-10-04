# frozen_string_literal: true

require 'sinatra'

current_dir = File.dirname(__FILE__)
views_dir = File.expand_path('../views', current_dir)

set :views, views_dir

get '/' do
  erb :candle
end
