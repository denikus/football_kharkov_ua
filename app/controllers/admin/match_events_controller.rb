class Admin::MatchEventsController < ApplicationController
  def index
    events = MatchEvent.all(
      :conditions => ['match_id = ?', params[:match_id]],
      :include => [:match, :event]
    )
    result = {
      :total_count => events.length,
      :rows => events.collect do |e|
        {
          :id => e.id,
          :match_id => e.match_id,
          :period => e.minute <= e.match.period_duration ? 1 : 2,
          :minute => e.minute,
          :source => case e.event_type
            when 'MatchMiscEvent': "Общее (#{e.event.event_type})"
            when 'MatchPlayerEvent': "#{e.event.football_player.number} #{e.event.football_player.footballer.last_name}"
            when 'MatchTeamEvent': e.event.competitor.team.name
          end,
          :message => e.message
        }
      end.sort_by{ |e| e[:minute] }.reverse
    }
    render :json => result.to_json
  end
  
  def create
    event_type_params = params[:match_event].delete(:event_type_params)
    event_klass = "match_#{params[:match_event][:event_type]}_event".camelize.constantize
    @event = event_klass.new(event_type_params[params[:match_event][:event_type]].merge({:match_event => MatchEvent.new(params[:match_event].merge({:match_id => params[:match_id]}))}))
    
    respond_to do |format|
      if @event.save
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
        format.ext_json  { render :json => {:success => true} }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @event.to_ext_json(:success => false) }
      end
    end
  end
  
  def destroy
    MatchEvent.find(params[:id]).event.destroy
    render :json => {:success => true}
  end
end
