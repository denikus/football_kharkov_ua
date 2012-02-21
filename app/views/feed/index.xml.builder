xml.instruct!
xml.rss "version" => "2.0" , "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title "Душевный футбол: #{@feed[:title] unless @feed.nil?}"
    xml.link url_for(:only_path => false,
                     :controller => 'blog' ,
                     :action => 'index' )
    xml.pubDate(CGI.rfc1123_date(@posts.first.updated_at.to_time))  unless @posts.empty?
    xml.description h("#{@feed[:title] unless @feed.nil?}: RSS лeнта" )
    @posts.each do |post|
      xml.item do
        xml.title post.title
        unless post.resource_type=='Status'
          xml.link post_url(:only_path => false,
                     :year => post.created_at.strftime('%Y'),
                     :month => post.created_at.strftime('%m'),
                     :day => post.created_at.strftime('%d'),
                     :url => !post.url.nil? ? post.url : '')
        else
          xml.link status_url(post.resource_id)
        end

        unless post.resource_type=='schedule_post'
          xml.description Hpricot(article_announce(post.resource['body'])).to_html unless post.resource['body'].nil?
        else
          xml.description Hpricot(article_announce(post.resource['generated_body'])).to_html unless post.resource['generated_body'].nil?
        end
        xml.pubDate CGI.rfc1123_date(post.updated_at.to_time)
        unless post.resource_type=='Status'
          xml.guid post_url(:only_path => false,
                     :year => post.created_at.strftime('%Y'),
                     :month => post.created_at.strftime('%m'),
                     :day => post.created_at.strftime('%d'),
                     :url => !post.url.nil? ? post.url : '')
        else
          xml.link status_url(post.resource_id)
        end
#        xml.guid post_url(:only_path => false,
#                     :year => post.created_at.strftime('%Y'),
#                     :month => post.created_at.strftime('%m'),
#                     :day => post.created_at.strftime('%d'),
#                     :url => !post.url.nil? ? post.url : '')
        xml.author h(User.find(post.author_id).username)
      end
    end
  end
end
