class OauthProviderController < ApplicationController
  before_filter :authenticate_user!

  def callback
    unless current_user.footballer.nil?
      flash[:warning] = 'К вашему профилю уже привязан игрок!'
    end

    @user_json = request.env['omniauth.auth']

    if @user_json["uid"].nil?
      flash[:error] = 'Ошибка авторизации попробуйте еще раз!'
    else
      user_request = UserConnectFootballerRequest.new({:provider_uid => @user_json["uid"], :provider => @user_json["provider"], :provider_data => Marshal.dump(@user_json["user_info"]), :user_id => current_user.id, :footballer_id => cookies[:request_footballer_id]})
      if user_request.valid?
        user_request.save
        flash[:notice] = 'Ваш запрос успешно создан и будет обработан в течение суток!'
      else
        flash[:error] = 'Что-то пошло не так! Возможно к вашему профилю уже привязан профиль игрока!'
      end
    end

  end

  def failure
    flash[:error] = 'Ошибка авторизации попробуйте еще раз!'
  end

  def create
    cookies[:request_footballer_id] = params[:footballer_id]
    redirect_to "/auth/#{params["provider"]}"
  end

  def scan_auth
    params[:user_connect_footballer_request].merge!({:user_id => current_user.id, :provider => "scan_auth"})
    user_request = UserConnectFootballerRequest.new(params[:user_connect_footballer_request])

    unless user_request.valid?
      flash[:error] = 'Что-то пошло не так! Возможно к вашему профилю уже привязан профиль игрока!'
    else
      user_request.save
      flash[:notice] = 'Ваш запрос успешно создан и будет обработан в течение суток!'
    end

  end
end