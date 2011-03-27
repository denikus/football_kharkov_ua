class CreateFootballers < ActiveRecord::Migration
  def self.up
    create_table :footballers do |t|
      t.integer :user_id, :null => true, :default => nil
      t.string :first_name, :null => false, :limit => 255
      t.string :last_name, :null => false, :limit => 255
      t.string :patronymic, :null => true, :limit => 255
      t.date :birth_date, :null => true, :default => nil
      t.timestamps
    end
  end

  def self.down
    drop_table :footballers
  end
end
