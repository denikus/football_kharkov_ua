class CreateLeagueTags < ActiveRecord::Migration
  def change
    create_table :league_tags do |t|
      t.integer :step_season_id, :references => [:steps, :id], :name => :fk_season_2_league_tag, :on_delete => :no_action
      t.string :name
      t.timestamps
    end
  end
end
