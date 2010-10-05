class BombardiersController < ApplicationController
  layout "app_without_sidebar"

  def index
    ap @stat = Stat.find(:all, :select => "stats.*, COUNT(value) AS goal_count ", :conditions => ["name = ? ", "goal"], :group => "statable_id")
    debugger
  end
end
