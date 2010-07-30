class MatchEventTypesController < ApplicationController
  # GET /match_event_types
  # GET /match_event_types.xml
  def index
    @match_event_types = MatchEventType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @match_event_types }
    end
  end

  # GET /match_event_types/1
  # GET /match_event_types/1.xml
  def show
    @match_event_type = MatchEventType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @match_event_type }
    end
  end

  # GET /match_event_types/new
  # GET /match_event_types/new.xml
  def new
    @match_event_type = MatchEventType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @match_event_type }
    end
  end

  # GET /match_event_types/1/edit
  def edit
    @match_event_type = MatchEventType.find(params[:id])
  end

  # POST /match_event_types
  # POST /match_event_types.xml
  def create
    @match_event_type = MatchEventType.new(params[:match_event_type])

    respond_to do |format|
      if @match_event_type.save
        flash[:notice] = 'MatchEventType was successfully created.'
        format.html { redirect_to(@match_event_type) }
        format.xml  { render :xml => @match_event_type, :status => :created, :location => @match_event_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @match_event_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /match_event_types/1
  # PUT /match_event_types/1.xml
  def update
    @match_event_type = MatchEventType.find(params[:id])

    respond_to do |format|
      if @match_event_type.update_attributes(params[:match_event_type])
        flash[:notice] = 'MatchEventType was successfully updated.'
        format.html { redirect_to(@match_event_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @match_event_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /match_event_types/1
  # DELETE /match_event_types/1.xml
  def destroy
    @match_event_type = MatchEventType.find(params[:id])
    @match_event_type.destroy

    respond_to do |format|
      format.html { redirect_to(match_event_types_url) }
      format.xml  { head :ok }
    end
  end
end
