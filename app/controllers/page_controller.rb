# -*- encoding : utf-8 -*-
#require 'digest/sha2'
class PageController < ApplicationController
  def index
    @pages = Page.find(:all)
  end

  def show
    @page = Page.find(params[:id].to_i)
  end
end
