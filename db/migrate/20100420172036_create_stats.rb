class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.integer :statable_id, :references => nil
      t.string :statable_type
      t.integer :statistic_id, :references => [:statistics, :id], :name => :fk_statistics_stats, :on_delete => :cascade
      t.integer :statistic_value
    end
  end

  def self.down
    drop_table :stats
  end
end
