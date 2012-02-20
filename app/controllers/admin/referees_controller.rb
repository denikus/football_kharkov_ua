# -*- encoding : utf-8 -*-
class Admin::RefereesController < ApplicationController
  layout 'admin/main'
  
#  admin_section :personnel
  
  def index
    respond_to do |format|
      format.html
      format.json do
        referees = Referee.all
        render :json => {
          'personnel' => referees.map{ |f| Hash[*%w{id first_name last_name patronymic birth_date name}.tap{ |a| a.replace a.zip(a.map{ |m| f.send(m) }).flatten }] },
          'count' => referees.length
        }
      end
    end
  end
  
  def create
    @referee = Referee.new(params[:referees])
    respond_to do |format|
      if @referee.save
        format.json { render :json => {:success => true} }
      else
        format.json{ render :json => {:success => false} }
      end
    end
  end
  
  def update
    @referee = Referee.find params[:id]
    
    respond_to do |format|
      if @referee.update_attributes(params[:referees])
        format.html { redirect_to([:admin, @referee]) }
        format.json  { render :json => {:success => true} }
      else
        format.html { redirect_to([:admin, @referee]) }
        format.json { render  :json => @referee.to_ext_json(:success => false) }
      end
    end
  end
  
  def destroy
    @referee = Referee.find params[:id]
    @referee.destroy
    
    respond_to do |format|
      format.html{ redirect_to admin_referees_path }
      format.json{ render :json => {:success => true} }
    end
  end
end
