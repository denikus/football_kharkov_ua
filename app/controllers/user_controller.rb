class UserController < ApplicationController
  
  def register
    @user = User.new
  end
  
  def signup
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:new_user_id] = @user.id
        format.html { redirect_to(:controller => 'user', :action => 'registration_finished', :id => @user.id) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "register" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def registration_finished
    flash[:notice] = "Вы успешно зарегистрировались!"
    redirect_to(:controller => 'blog', :action => 'index')
  end

  def access_denied
    
  end
end
