class TablesController < ApplicationController
  layout "app_without_sidebar"
  
  def index
#    params[:id] = 10
#    @set = StepLeague.for_table.find(10).table_set
#    @set = []
#    StepLeague.for_table.find(:all, :conditions => {:id => [10,11,12,13,14]}).map(&:last_table).each do |table|
#    StepLeague.for_table.find(:all, :conditions => {:id => [10]}).each do |table|
#      @set << {:table => table.table_set[0], :league_name => table.name}
#    end

#    ap @tables = StepLeague.for_table.find([10]).map(&:last_table)
#    debugger
#    render :partial => 'table', :collection => @tables

#    puts "------------set"
#    ap @set
#    @set.each do |league|
#      league[:table].sort{ |a,b| a[1]<=>b[1]}
#      debugger
#    end
#    debugger
#    ap @set.count
#    puts "------set"
#    render :layout => false
#    [10,11,12,13,14]
#    ap @set = StepLeague.for_table.find(params[:id]).table_set
#    puts '---------------------------'
#    @sets = {:league => StepLeague.find}
    tournament = Tournament.find_by_url(current_subdomain)

    @stages = tournament.step_seasons.find(:last, :order => "identifier ASC").stages.find(:all, :order => "identifier DESC")

    leagues = []
    @stages.each{ |stage| stage.leagues.collect{|x| leagues << x.id }}

    @leagues = StepLeague.for_table.find(leagues)
#    @leagues = StepLeague.for_table.find([10,11,12,13,14])
#    @set = StepLeague.for_table.find(10).table_set
#    @sets = []
    @leagues.each do |league|
      @sets << {:table_set => league.table_set, :league => league}
    end

  end
end
