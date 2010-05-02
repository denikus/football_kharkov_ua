class ProfilesController < ApplicationController
  before_filter :find_user_profile
  before_filter :authenticate_user!, :only => [:edit, :update]
  before_filter :check_user_profile, :only => [:edit, :update]
  
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
  end
  
  # GET /users/1/profile/edit
  def edit
  end
  
  # PUT /users/1/profile
  # PUT /users/1.xml
  def update
    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        flash[:notice] = "Ваш профиль успешно обновлён"
        format.html { redirect_to(user_profile_path(current_user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
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
