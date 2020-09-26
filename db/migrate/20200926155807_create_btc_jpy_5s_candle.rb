# frozen_string_literal: true

class CreateBtcJpy5sCandle < ActiveRecord::Migration[6.0]
  def up
    create_table :btc_jpy_5s_candles do |t|
      t.datetime :time, null: false
      t.float :open, null: false
      t.float :close, null: false
      t.float :high, null: false
      t.float :low, null: false
      t.integer :volume, null: false
    end
  end

  def down
    drop_table :btc_jpy_5s_candles
  end
end
