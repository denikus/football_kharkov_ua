class AddOttPath2Team < ActiveRecord::Migration
  def up
    add_column :teams, :ott_path, :string
  end

  def down
    remove_column :teams, :ott_path
  end
end
