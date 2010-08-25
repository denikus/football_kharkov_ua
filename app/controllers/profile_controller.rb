class ProfileController < ApplicationController
#  before_filter :authorize, :except => [:index]
#  before_filter :authorize, :except => [:index]
  before_filter :authenticate_user!, :except => [:index]

  def index
    @user = User.find(:first, :conditions => [' username = ?', params[:username]])
  end

  def edit_account
    
  end

  def edit_profile
    @profile = User.find(:first, session[:user]).profile
  end

  def update_profile
    @profile = User.find(:first, session[:user]).profile
    @profile.update_attributes(params[:profile])
    flash[:notice] = "Данные успешно обновлены"
    redirect_to :action => :edit_profile
  end

  def edit_photo
    
  end

  def update_photo
    
  end

  def crop
    
  end

end
