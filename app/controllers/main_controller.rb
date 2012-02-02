# -*- encoding : utf-8 -*-
class MainController < ApplicationController
  layout 'application'

  def generate_sitemap
#    response.headers['Content-Type'] = "application/xml"
    @posts = Post.find :all, :limit => 50000, :order => "created_at DESC"
    
    xml_content = render_to_string :template => "main/generate_sitemap.rxml", :layout => false

    xml_file = File.new("#{RAILS_ROOT}/public/sitemap.xml", "w+")
    $stdout = xml_file
    print xml_content
    $stdout = STDOUT
    xml_file.close

    render :text => 'Sitemap успешно сгенерирован!'
  end

end
