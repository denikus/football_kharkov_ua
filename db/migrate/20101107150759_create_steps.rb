class CreateSteps < ActiveRecord::Migration
  def self.up
    create_table :steps do |t|
      t.string :type
      t.integer :tournament_id
      t.integer :identifier
      t.string :name
      t.string :url
      t.timestamps
    end
    
    create_table :steps_phases, :id => false do |t|
      t.integer :step_id
      t.integer :phase_id
    end
  end

  def self.down
    drop_table :steps
    drop_table :steps_phases
  end
end
