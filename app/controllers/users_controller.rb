require 'uri'
require 'net/http'

class UsersController < ApplicationController
  layout 'user', :only => "show"
  #layout 'application', :only => [:new, :create]
  
  # GET /users/1
  # GET /users/1.xml
  def show
    @title = 'Профиль'
    @profile = User.from_param(params[:id]).profile

    params[:page] = 1 if !params[:page]
    @posts = Post.paginate(:page => params[:page], :per_page => 5, :order => 'created_at DESC', :conditions => {:author_id => @profile.user_id})
    render :template => "blog/index"
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    
    respond_to do |format|
      format.html # _new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  # POST /user.xml
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        flash[:notice] = 'Вам выслано письмо с подтверждением вашего аккаунта.'
#        create_forum_user_for_user @user
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new", :layout => "application" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def feed
    @profile = User.from_param(params[:id]).profile
    @posts = Post.paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC', :conditions => {:author_id => @profile.user_id})
    @feed = {:title => "Футбольная лента #{@profile.user.username}"}
    render :layout=>false, :template => "feed/index"
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end

  private
  
#  def create_forum_user_for_user user
#    #uri = URI.parse("http://football.artemka.sv/football_forum/create_user.php")
#    #random_password = Digest::SHA1.hexdigest(Time.now.to_s)
#
#    res = Net::HTTP.post_form(URI.join(FORUM[:location], FORUM[:create_user]), {
#      'from_rails' => 'true',
#      'rails_secret' => FORUM[:secret],
#      'PostBackAction' => 'Apply',
#      'ReadTerms' => '0',
#      'Email' => user.email,
#      'Name' => user.username,
#      'NewPassword' => params['user']['password'],
#      'ConfirmPassword' => params['user']['password_confirmation'],
#      'AgreeToTerms' => '1'
#    })
#    #puts res.body
#  end
  
end
