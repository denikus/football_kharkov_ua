class UpdateCompetitorsAddFouls < ActiveRecord::Migration
  def self.up
    add_column :competitors, :fouls, :integer, :limit => 2, :null => false, :default => 0
  end

  def self.down
    remove_column :competitors, :fouls
  end
end
