# -*- encoding : utf-8 -*-
require 'secured.rb'

class Admin::UsersController < ApplicationController
  include Secured
  
  before_filter :authenticate_admin!
  before_filter permit :admin
  
  def index
    @users = User.find(:all)
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      self.logged_in_user = @user
      flash[:notice] = "Your account has been created."
      redirect_to :action=>'index'
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to :action => 'index'
  end
  
  secure :show, :new, :create, :edit, :update
end
