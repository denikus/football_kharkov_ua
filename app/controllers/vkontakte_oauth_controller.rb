class VkontakteOauthController < ApplicationController

  def callback
#    auth = request.env["rack.auth"]
    
#    access_token = client.web_server.get_access_token(
#      params[:code], :redirect_uri => vkontakte_oauth_url(:action => "callback")
#    )
    ap @user_json = request.env['omniauth.auth']

    # in reality you would at this point store the access_token.token value as well as
    # any user info you wanted

#    render :json => user_json
  end

end
