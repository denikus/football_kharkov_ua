class VkontakteOauthController < ApplicationController

  def callback
    access_token = client.web_server.get_access_token(
      params[:code], :redirect_uri => vkontakte_oauth_url(:action => "callback")
    )

    @user_json = access_token.get('/me')
    # in reality you would at this point store the access_token.token value as well as
    # any user info you wanted

#    render :json => user_json
  end

end
