# -*- encoding : utf-8 -*-
class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :status_type, :default => "personal"
    end
  end

  def self.down
    drop_table :statuses
  end
end
