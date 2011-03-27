class CreateStepProperties < ActiveRecord::Migration
  def self.up
    create_table :step_properties do |t|
      t.integer :step_id
      t.string :property_name
      t.string :property_value
    end
  end

  def self.down
    drop_table :step_properties
  end
end
