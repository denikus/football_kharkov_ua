# -*- encoding : utf-8 -*-
class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.string :symbol
      t.string :name
    end
  end

  def self.down
    drop_table :statistics
  end
end
