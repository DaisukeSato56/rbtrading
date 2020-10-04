# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'

class Webserver < Sinatra::Base
  register Sinatra::Reloader

  current_dir = File.dirname(__FILE__)
  views_dir = File.expand_path('../views', current_dir)
  set :views, views_dir

  get '/' do
    @candle = 'candle'
    erb :candle
  end
end
