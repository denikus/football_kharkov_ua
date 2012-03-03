# -*- encoding : utf-8 -*-
class FootballerCell < Cell::Rails
  helper UrlHelper
  helper ApplicationHelper
  include Devise::Controllers::Helpers
  helper_method :current_user #all your needed helper


  def sidebar
    id = params[:id].nil? ? params[:footballer_id] : params[:id]
    @footballer = Footballer.find_by_url(id)
    
    render
  end

  def future_matches_block(args)
    @opts = args
    if !current_user.nil? && !current_user.footballer.nil?
      @schedules = Schedule.future_footballer_matches(current_user.footballer.id)
      render
    end

  end
end
