class TablesController < ApplicationController
  layout "app_without_sidebar"
  
  def index
    params[:id] = 10
#    @set = StepLeague.for_table.find(10).table_set
    @set = []
    StepLeague.for_table.find(:all, :conditions => {:id => [10,11,12,13,14]}).each do |table|
      @set << {:table => table.table_set[0], :league_name => table.name}
    end

    render :partial => "tables/#{current_subdomain}_table"
#    puts "------------set"
#    ap @set
#    debugger
#    ap @set.count
#    puts "------set"
#    render :layout => false
  end
end
