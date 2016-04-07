class AddOttPlayerId < ActiveRecord::Migration
  def up
    add_column :footballers, :ott_player_id, :integer
  end

  def down
    remove_column :footballers, :ott_player_id
  end
end
