class ScheduleController < ApplicationController
before_filter :authenticate_user!, :except => [:show]
before_filter :check_permissions, :except => [:show, :new, :create, :upload_image]

def new
  @schedule_post = Schedule.new
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
end
