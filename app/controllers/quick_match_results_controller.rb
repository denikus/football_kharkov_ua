class QuickMatchResultsController < ApplicationController
  def show
    render :json => {:content => render_cell(:sidebar_block, :quick_results,
                                             :locals => {:current_subdomain => current_subdomain,
                                                         :direction => params[:direction],
                                                         :current_date => params[:current_date],
                                                         :direction_date => params[:direction_date]}),
                     :formatted_date => Russian::strftime(params[:direction_date].to_date, "%a, %d %B '%y")
                    },
           :layout => false
  end
end
