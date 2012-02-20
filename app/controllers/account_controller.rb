# -*- encoding : utf-8 -*-
class AccountController < ApplicationController
 
  def authenticate
    self.logged_in_user = User.authenticate(params[:user][:username], params[:user][:password])
    
    if is_logged_in?
      session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(:controller=>'blog', :action=>'index')
      session[:return_to] = nil
    else
      flash[:error] = "Ошибка в логине или пароле!"
      redirect_to :action => 'login'
    end
  end

  def logout
      reset_session
      flash[:notice] = "Вы успешно вышли!"
      redirect_to :controller=>'blog', :action=>'index'
  end
  
  def profile
    @user = User.find(session[:user])
    if request.post?
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Ваш профиль успешно обновлен!'
      end
    end
  end

  def show
    
  end

end
