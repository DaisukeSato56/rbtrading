# frozen_string_literal: true

require './config/config'

def main
  conf = ConfigList.new
  puts conf.api_key
  puts conf.api_secret
end

main if __FILE__ == $PROGRAM_NAME
