# frozen_string_literal: true

require_relative '../../config/init.rb'
require_relative '../../constants.rb'

class StreamData
  def stream_ingestion_data; end

  # TODO：Procオブジェクトとして定義し、streamdataをえる関数に渡す
  def trade(ticker); end
end
