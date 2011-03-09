require 'secured.rb'
class Admin::PermissionsController < ApplicationController
  include Secured

  before_filter :authenticate_admin!
  before_filter permit :admin

  def index
    #require all controllers
    Dir.new("#{RAILS_ROOT}/app/controllers/admin").entries.each{ |entry| eval("Admin::#{entry[0..-4].camelize}") if !File.directory?(entry) and entry =~ /controller\.rb$/ }
    admins = Admin.regular
    controllers = subclasses_of(ApplicationController).select{ |c| c.name =~ /Admin::/ and c.ancestors.include?(Secured) and !c.secured_actions.empty? }
    permissions = Permission.get_hash

    tree = '[' + admins.collect do |admin|
      "{text: '#{admin.full_name}', cls: 'folder', children: ["+
        controllers.collect{ |c| "{text: '#{c.name}', cls: 'folder', children: [" +
          c.secured_actions.collect{ |a| "{text: '#{a}', leaf: true, checked: #{permissions.lookup("#{admin.id}>#{c.name}>#{a}") || false}}" }.join(',') +
        "]}" }.join(',') +
      "]}"
    end.join(',') + ']'
    render :json => tree
  end

  def create
    params[:permission][:admin_id] = Admin.find_by_full_name(params[:permission].delete(:admin)).id
    Permission.create(params[:permission])

    render :json => {:status => :success}.to_json
  end

  def destroy
    #Permission.find(params[:id]).destroy
    params[:permission][:admin_id] = Admin.find_by_full_name(params[:permission].delete(:admin)).id
    Permission.first(:conditions => params[:permission]).destroy
    render :json => {:status => :success}.to_json
  end

  secure :create, :delete
end
