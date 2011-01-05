class TablesController < ApplicationController
  layout "app_without_sidebar"
  
  def index
    params[:id] = 10
    ap @set = StepLeague.for_table.find(params[:id]).table_set
#    render :layout => false
  end
end
