# frozen_string_literal: true

require './config/config'
require './bitflyer/bitflyer'

def main
  conf = ConfigList.new
  b = APIClient.new(conf.api_key, conf.api_secret)
  b.do_request('GET', 'getboard', '', '')
end

main if __FILE__ == $PROGRAM_NAME
