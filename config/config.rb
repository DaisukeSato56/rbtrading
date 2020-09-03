# frozen_string_literal: true

require 'yaml'

class ConfigList
  attr_reader :api_key, :api_secret, :product_code, :trade_duration, :db_name, :sql_driver, :port

  def initialize
    conf = YAML.load_file('config.yml')
    @api_key = conf['bitflyer']['api_key']
    @api_secret = conf['bitflyer']['api_secret']
    @product_code = conf['rbtrading']['product_code']
    @trade_duration = conf['rbtrading']['trade_duration']
    @db_name = conf['db']['name']
    @sql_driver = conf['db']['driver']
    @port = conf['web']['port']
  end
end
