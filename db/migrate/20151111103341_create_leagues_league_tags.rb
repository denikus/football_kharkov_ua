class CreateLeaguesLeagueTags < ActiveRecord::Migration
  def change
    create_table :leagues_league_tags do |t|
      t.integer :step_league_id, :references => [:steps, :id], :name => :fk_leagues_2_league_tag, :on_delete => :no_action
      t.integer :league_tag_id, :references => [:league_tags, :id], :name => :fk_league_tag, :on_delete => :no_action
      t.timestamps
    end

    season = StepSeason.find(502)
    senior = season.league_tags.create(name: 'Senior Лига')
    middle = season.league_tags.create(name: 'Middle Лига')
    junior = season.league_tags.create(name: 'Junior Лига')

    senior.step_leagues << StepLeague.find(506)
    middle.step_leagues << StepLeague.find(505)
    junior.step_leagues << StepLeague.find(504)

  end
end
