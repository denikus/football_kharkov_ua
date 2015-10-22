# -*- encoding : utf-8 -*-
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

  def upload_photo
    current_user.profile.attributes = params[:profile]
    current_user.profile.save!

    redirect_to :action => :edit_photo
  end

  def make_crop
    # ap params[:profile]
    current_user.profile.attributes = params[:profile]
    current_user.profile.save!

    redirect_to :action => :edit_photo
  end


  def update_photo
    
  end

  def crop
    
  end

end
