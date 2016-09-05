class Admin::AwardsController < ApplicationController
  before_filter :authenticate_admin!

  layout "admin/temp"

  def index

  end
end
