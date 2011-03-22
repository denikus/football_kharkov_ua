#class UserCell < ::Cell::Base
class UserCell < Cell::Rails
  include Devise::Controllers::Helpers
#  helper_method :current_user #all your needed helper
  
  def sidebar
    if request.parameters[:controller] == "users"
      @profile = User.from_param(params[:id]).profile
    else
      @profile = User.find(current_user.id).profile
    end
    render
  end
end
