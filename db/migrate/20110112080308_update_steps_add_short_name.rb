class UpdateStepsAddShortName < ActiveRecord::Migration
  def self.up
    add_column :steps, :short_name, :string, :default => nil
  end

  def self.down
    remove_column :steps, :short_name
  end
end
