class VkontakteOauthController < ApplicationController
  def start
    redirect_to client.web_server.authorize_url(
      :redirect_uri => vkontakte_oauth_url(:action => "callback")
    )
  end

  def callback
    access_token = client.web_server.get_access_token(
      params[:code], :redirect_uri => vkontakte_oauth_url(:action => "callback")
    )

    @user_json = access_token.get('/me')
    # in reality you would at this point store the access_token.token value as well as
    # any user info you wanted

#    render :json => user_json
  end

  private
  
  def client
    @client ||= OAuth2::Client.new(
      '2304423', 'BPQpptM8Asx45sxdtlhC', :site => 'http://api.vk.com/oauth/authorize?display=page'
    )
  end
end
