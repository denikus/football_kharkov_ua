class AddOttUidToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :ott_uid, :string
  end
end
