require 'open-uri'

class Admin::ImportController < ApplicationController
  before_filter :authenticate_admin!

  layout "admin/temp"


  def index
    @seasons = StepSeason.by_tournament(4)

    @stages = @seasons.first.stages

    #get league page (need: league name)
    #url = "http://liga.metalist.ua/tournaments/15/standings/51/"
    #doc = Nokogiri::HTML(open(url))
    #title = doc.at_css("title").text.split(' | ')
    #first_word = title[0].strip
    #
    ##get league teams' names
    #doc.css("div.table-result table tr").each do |item|
    #  unless item.at_css("td.team").nil?
    #    puts item.at_css("td.team").text
    #  end
    #end
    #debugger
  end

  def create

    #get league page (need: league name)
    url = "http://liga.metalist.ua/tournaments/15/standings/51/"
    doc = Nokogiri::HTML(open(url))
    title = doc.at_css("title").text.split(' | ')

    new_league = StepLeague.create({:name => title[0].strip, :tournament_id => Step.find(params[:stage_id]).tournament_id})
    Step.find(params[:stage_id]).send('leagues').push(new_league) if params[:stage_id]

    #get league teams' names
    #doc.css("div.table-result table tr").each do |item|
    #  unless item.at_css("td.team").nil?
    #
    #  end
    #end


    #get league teams' names

    

    #create league if not exists
    #StepLeague.new(params[:])
  end

end
