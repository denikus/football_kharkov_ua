class UserCell < ::Cell::Base
  def sidebar
    if controller.request.parameters[:controller] == "users"
      @profile = User.from_param(params[:id]).profile
    else
      @profile = User.find(controller.current_user.id).profile
    end
    render
  end
end
