class SchedulePostController < ApplicationController
before_filter :authenticate_user!, :except => [:show]
before_filter :check_permissions, :except => [:show, :new, :create, :upload_image]

  def new
    @schedule_post = SchedulePost.new
  end

  def create
    @schedule_post = SchedulePost.new(params[:schedule_post])
    @post = Post.new({:author_id=>current_user[:id], :title => params[:post][:title],
                      :tag_list => params[:post][:tag_list], :status => params[:post][:status],
                      :hide_comments => params[:post][:hide_comments],
                      :tournament_id => params[:post][:tournament_id]
                     })

    @post.resource = @schedule_post
    respond_to do |format|
      if @post.save
        flash[:notice] = "Расписание тура успешно сохранено"
        format.html { redirect_to(:controller => 'blog', :action => 'index') }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @schedule_post = SchedulePost.find(params[:id])
  end

  def update
    @schedule_post = SchedulePost.find(params[:id])
    respond_to do |format|
      if @schedule_post.update_attributes(params[:schedule_post]) && @schedule_post.post.update_attributes(params[:post])
        flash[:notice] = "Расписание успешно сохранено"
        format.html { redirect_to(:controller => 'blog', :action => 'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @schedule_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show

  end

  private

  def check_permissions
    schedule_post = SchedulePost.find(params[:id])
    post = schedule_post.post
    if post.author_id!=current_user[:id] && current_user[:id] != 1
      flash[:error] = "Недостаточно прав для данного действия!"
      redirect_to post_url({:year => post.created_at.strftime('%Y'), :month => post.created_at.strftime('%m'), :day => post.created_at.strftime('%d'), :url => !post.url.nil? ? post.url : ''})
    end
  end

end
