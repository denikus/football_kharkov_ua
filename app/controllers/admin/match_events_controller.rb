class Admin::MatchEventsController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        events = MatchEvent.find(:all, :conditions => {:match_id => params[:id]}, :order => 'minute DESC') do
          paginate :page => params[:page], :per_page => params[:rows]
        end
        render :json => events.to_jqgrid_json([:minute, :message], params[:page], params[:rows], events.total_entries)
      end
    end
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
