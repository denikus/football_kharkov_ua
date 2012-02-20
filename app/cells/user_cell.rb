# -*- encoding : utf-8 -*-
class UserCell < Cell::Rails
  include Devise::Controllers::Helpers

  def sidebar(args)
    @opts = args
    if request.parameters[:controller] == "users"
      @profile = User.from_param(params[:id]).profile
    else
      @profile = User.find(current_user.id).profile
    end
    render
  end

  def statbar
    @profile = User.from_param(params[:id]).profile
    render
  end
end
