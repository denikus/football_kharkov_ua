class FootballersController < ApplicationController
  layout "footballer"

  before_filter :redirect_to_main_domain
  before_filter :authenticate_user!, :except => [:show, :its_me]
  before_filter :check_permission, :except => [:show, :its_me]

  def show
    @footballer = Footballer.find_by_url(params[:id])

    @title = "Футболист: #{@footballer.full_name}"

    tournaments = @footballer.footballers_teams.joins(:step).group("steps.tournament_id").collect{|item| item.step.tournament}

    @tournaments_teams = []

    tournaments.each do |tournament|
      last_season = StepSeason.by_footballer(@footballer.id).by_tournament(tournament.id).last
      last_season_teams = @footballer.footballers_teams.includes(:team).where('step_id = ?', last_season)

      @team_stats = []
      last_season_teams.each do |footballer_team|
        team = footballer_team.team
        matches = []
        #count total number of team matches in current season
        footballer_team.step.stages.collect{|stage| stage.tours.map{|tour| tour.schedules.map{|schedule| matches << schedule.match if (!schedule.host_scores.nil? && (schedule.host_team_id == team.id || schedule.guest_team_id == team.id)) }}}

        #count number of matches played by the footballer
        played_matches = Match.played_by_footballer(matches.collect{|m| m.id}, team.id, @footballer.id)

        #get competitors by season
        competitors = Competitor.by_team_matches(team.id, played_matches)

        #get football_players by season
        football_players = FootballPlayer.by_competitor_footballer(competitors.collect{|c| c.id}, @footballer.id)

        #get statistic for football_players
        stats = Stat.by_football_players(football_players.collect{|x| x.id})
        statistic = {}
        FootballPlayer::STATS.each{|s| statistic.merge!({s.to_sym => nil})}
        stats.each{|item| statistic[item[:name].to_sym] = item["stat_count"]}
        
        @team_stats << {:team => team,
                   :league =>  team.get_league(@footballer.id, last_season.id),
                   :total_team_matches => matches.count,
                   :footballer_matches => played_matches.count,
                   :goal => statistic[:goal],
                   :auto_goal => statistic[:auto_goal],
                   :yellow_card => statistic[:yellow_card],
                   :red_card => statistic[:red_card]
                   }
      end
      @tournaments_teams << {
                             :tournament => tournament,
                             :season => last_season,
                             :teams_stats => @team_stats
                            }
    end
    @schedules = Schedule.future_footballer_matches(@footballer.id)
  end

  def its_me
    @title = "Заявка на управление странице футболиста"
    @footballer = Footballer.find_by_url(params[:footballer_id])
  end

  def edit_photo
    @title = "Редактирование фотографии"
  end

#  def update_photo
#    @footballer.attributes = params[:footballer]
#    @footballer.save!
#
#    redirect_to edit_photo_footballer_path(@footballer.url)
#  end

  def upload_photo
    @footballer.attributes = params[:footballer]
    @footballer.save!

    redirect_to :action => :edit_photo
  end

  def make_crop
    @footballer.attributes = params[:footballer]
    @footballer.profile.save!

    redirect_to :action => :edit_photo
  end

  def destroy_photo
    current_user.profile.photo = nil
    if current_user.profile.save!
      flash[:success] = "Фото успешно удалено"
    end

    redirect_to :action => :edit_photo
  end

  private

  def redirect_to_main_domain
    unless current_subdomain.nil?
      redirect_params = {:subdomain => nil, :id => params[:id] }
      redirect_to footballer_url(redirect_params), :status=>301
    end
  end

  def check_permission
    @footballer = Footballer.find_by_url(params[:footballer_id])
    unless @footballer.user_id == current_user.id
      redirect_to footballer_path(@footballer.url)
    end
  end
end