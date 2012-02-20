# -*- encoding : utf-8 -*-
class PhotoGalleryController < ApplicationController
#  protect_from_forgery :except => [:upload_image]
  
#  before_filter :authorize, :except => [:show, :upload_image]
#  before_filter :check_permissions, :except => [:show, :new, :create, :upload_image]

  before_filter :authenticate_user!, :except => [:show, :upload_image]
  before_filter :check_permissions, :except => [:show, :new, :create, :upload_image]


  #session :cookie_only => false, :only => [:upload_image]
#  session :swfupload => true
  
  def new
    @photo_gallery = PhotoGallery.new
#    some_text = "method=post&session_id=bff452b28e740d4ebcee12721568ebcf"
#    match_text = some_text.match(/^.*session_id=(.*)$/)

  end

  def create
    #check is file exists
    respond_to do |format|
      if params[:picture].nil? || params[:picture].empty?
          flash[:error] = "Нет изображений для сохранения"
          format.html { redirect_to(:action => 'new') }
          format.xml  { render :xml => '', :status => :created }
      else
        @gallery = PhotoGallery.find(params[:gallery_id])
        @gallery.update_attributes(params[:photo_gallery])
        
        params[:picture].each do |filename, title|
          if photo = @gallery.photos.find(:first, :conditions => ['filename = ?', filename])
            attributes = {:title => title}
            photo.update_attributes(attributes)
          end
        end
#        @gallery.save
        @post = Post.new(:author_id=>1, :title=>params[:post]['title'])
        @post.resource = @gallery
        @post.save
        cookies['gallery_id'] = nil;
        flash[:notice] = "Галлерея успешно сохранена"
        format.html { redirect_to(:controller => :blog, :action => 'index') }
        format.xml  { render :xml => '', :status => :created }
      end
    end
    
  end
  
  def upload_image
    if params[:gallery_id].nil? || params[:gallery_id].to_i==0
      @gallery = PhotoGallery.new()
#      @gallery = PhotoGallery.new()
      @gallery.save
#      cookies[:gallery_id] = @gallery.id
      gallery_id            = @gallery.id
    else 
      gallery_id = params[:gallery_id]
      @gallery = PhotoGallery.find(gallery_id)
    end
=begin
    pp params[:photoupload][:file]
    puts params['Filename']
    pp session
=end
#    puts current_user[:id]
#    photo_data = {:filename => params['Filename'], :user_id => User.find(params['user_id']).id.to_s, :file => params[:photoupload]}
    user = User.find(params['user_id'])
    photo_data = {:filename => params['Filename'], :user_id => user[:id].to_s, :file => params[:photoupload][:file]}
    @gallery.photos << Photo.new(photo_data)
    @gallery.save
    return_data = {:result => "success", :size => 'All ok!', :gallery_id => gallery_id.to_s,  :path => '/user/' + user[:id].to_s + '/photo_gallery/' + gallery_id.to_s + '/thumbs/' }
    
    render :text => return_data.to_json, :layout => false
  end

  def edit
    @photo_gallery = PhotoGallery.find(params[:id])
  end

  def update
     respond_to do |format|
      if params[:picture].nil? || params[:picture].empty?
          flash[:notice] = "Нет изображений для сохранения"
          format.html { redirect_to(:action => 'new') }
          format.xml  { render :xml => '', :status => :created }
      else
        @gallery = PhotoGallery.find(params[:photo_gallery]["gallery_id"])
        @gallery.post.update_attributes(:title => params[:post][:title])
        
        params[:picture].each do |filename, title|
          if photo = @gallery.photos.find(:first, :conditions => ['filename = ?', filename])
            attributes = {:title => title}
            photo.update_attributes(attributes)
          end
        end
#        @gallery.save
#        @post = Post.new(:author_id=>session['member_id'])
#        @post.resource = @gallery
        @gallery.save
#        session['gallery_id'] = nil;
        flash[:notice] = "Галлерея успешно сохранена"
        format.html { redirect_to(:controller => :blog, :action => 'index') }
        format.xml  { render :xml => '', :status => :created }
      end
    end
  end

  def delete
    @photo_gallery = PhotoGallery.find(params[:id])
    respond_to do |format|
      if @photo_gallery.post.resource.destroy
        flash[:notice] = l(:member, "Галлерея успешно удалена")
        format.html { redirect_to(:controller => 'blog', :action => 'index') }
        format.xml  { head :ok }
      else   
        format.html { render :action => "edit", :id => params[:id] }
        format.xml  { render :xml => @photo_gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @photo_gallery = PhotoGallery.find(params[:id])
  end

  private

  def check_permissions
    gallery_id = params[:photo_gallery].nil? ? params['id'] : params[:photo_gallery]["gallery_id"]
    gallery = PhotoGallery.find(gallery_id)
    post = gallery.post
    if post.author_id!=current_user[:id] || post.author_id != 1
      flash[:error] = "Недостаточно прав для данного действия!"
      redirect_to post_url({:year => post.created_at.strftime('%Y'), :month => post.created_at.strftime('%m'), :day => post.created_at.strftime('%d'), :url => !post.url.nil? ? post.url : ''})
    end
  end

end
