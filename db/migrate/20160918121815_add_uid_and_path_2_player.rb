class AddUidAndPath2Player < ActiveRecord::Migration
  def up
    add_column :footballers, :ott_uid, :string
    add_column :footballers, :ott_path, :string
  end

  def down
    remove_column :footballers, :ott_uid
    remove_column :footballers, :ott_path

  end
end
