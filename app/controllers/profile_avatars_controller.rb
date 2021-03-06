# -*- encoding : utf-8 -*-
class ProfileAvatarsController < ApplicationController
#  before_filter :find_user_profile
  before_filter :authenticate_user!
#  before_filter :check_user_profile
  
  def show
  end
  
  def new
    @avatar = ProfileAvatar.new
  end
  
  def create
#    current_user.profile.attributes = params[:profile_avatar]
#    current_user.profile.save!
=begin
    @avatar = ProfileAvatar.new(params[:profile_avatar].merge({:profile_id => current_user.profile.id}))
#    extension = @avatar.filename[/\.[a-z]*$/i]
    @avatar.filename = "#{@user.id}_avatar#{extension}"
    if @avatar.save
      flash[:notice] = 'Картинка успешно добавлена.'
      redirect_to user_profile_path(@user)
    else
      render :action => :new
    end
=end
  end
  
  # GET /users/1/profile/photo/edit
  def edit
  end
  
  # PUT /users/1/profile/photo
  def update
#    @user.profile.profile_avatar.destroy
    current_user.profile.profile_avatar.attributes = params[:profile_avatar]
    current_user.profile.profile_avatar.save!

    redirect_to edit_user_profile_avatar_path(current_user)
=begin
    @avatar = ProfileAvatar.new(params[:profile_avatar].merge({:profile_id => @profile.id}))
    extension = @avatar.filename[/\.[a-z]*$/i]
    @avatar.filename = "#{@user.id}_avatar#{extension}"
    if @avatar.save
      flash[:notice] = 'Картинка успешно обновлена.'
      redirect_to user_profile_path(@user)
    else
      render :action => :new
    end
=end
  end
  
  protected
  
  def find_user_profile
    @user = User.from_param(params[:user_id])
    @profile = @user.profile
  end
  
  def check_user_profile
    redirect_to edit_user_profile_path(current_user) if @user != current_user
  end

end
