class MatchesController < ApplicationController
  layout "app_without_sidebar"

  def show
    @match = Match.find(:first,
                        :include => {:schedule => :step_tour},
                        :conditions => {:id => params[:id]}
                       )
  end
end
