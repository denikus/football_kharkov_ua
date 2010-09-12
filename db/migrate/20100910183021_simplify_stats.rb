class SimplifyStats < ActiveRecord::Migration
  def self.up
    drop_table :statistics
    remove_column :stats, :statistic_id
    remove_column :stats, :statistic_value
    add_column :stats, :name, :string
    add_column :stats, :value, :integer
    add_index :stats, :name
  end

  def self.down
    create_table :statistics do |t|
      t.string :symbol
      t.string :name
    end
    remove_column :stats, :name
    remove_column :stats, :value
    add_column :stats, :statistic_id, :integer
    add_column :stats, :statistic_value, :integer
  end
end
