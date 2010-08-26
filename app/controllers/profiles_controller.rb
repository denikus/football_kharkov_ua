class ProfilesController < ApplicationController
#  before_filter :find_user_profile
  before_filter :authenticate_user!, :except => [:show]
#  before_filter :check_user_profile, :only => [:edit, :update]
  layout "user" 
  
  def show
    redirect_to :controller => :users, :action => :show, :id => current_user.username
=begin
respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
=end
  end
  
  # GET /users/1/profile/edit
  def edit
    @title = "Редактирование профиля"
    @profile = current_user.profile
  end
  
  # PUT /users/1/profile
  # PUT /users/1.xml
  def update
    @profile = current_user.profile

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        flash[:notice] = "Ваш профиль успешно обновлён"
        format.html { redirect_to(profile_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit_photo
    @title = "Редактирование фотографии"
    @profile = current_user.profile
  end

  def update_photo
    current_user.profile.attributes = params[:profile]
    current_user.profile.save!

    redirect_to crop_user_profile_path(current_user)
  end

  def upload_photo
    current_user.profile.attributes = params[:profile]
    current_user.profile.save!

    redirect_to :action => :edit_photo
  end

  def make_crop
    current_user.profile.attributes = params[:profile]
    current_user.profile.save!

    redirect_to :action => :edit_photo
  end

  def destroy_photo
    current_user.profile.photo = nil
    if current_user.profile.save!
      flash[:success] = "Фото успешно удалено"
    end

    redirect_to :action => :edit_photo
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
