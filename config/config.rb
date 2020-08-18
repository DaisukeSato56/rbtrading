# frozen_string_literal: true

require 'yaml'

class ConfigList
  attr_reader :api_key, :api_secret

  def initialize
    conf = YAML.load_file('config.yml')
    @api_key = conf['bitflyer']['api_key']
    @api_secret = conf['bitflyer']['api_secret']
  end
end
