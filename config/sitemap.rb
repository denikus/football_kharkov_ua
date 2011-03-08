# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://football.kharkov.ua"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.yahoo_app_id = "f8482c9f62d5bdf433e8fd41d1d42d6a"
SitemapGenerator::Sitemap.add_links do |sitemap|
   host = 'football.kharkov.ua'
   Post.find_each do |post_item|
#     sitemap.add post_path(post), :lastmod => post.updated_at, :priority => 0.7
     if post_item.tournament.nil?
       with_subdomain = host
     else
       with_subdomain = [post_item.tournament.url, host].join
     end
     sitemap.add post_url({:year => post_item.url_year,
               :month => post_item.url_month,
               :day => post_item.url_day,
               :url => !post_item.url.nil? ? post_item.url : '',
               :host => with_subdomain
              }), :lastmod => post_item.updated_at, :priority => 0.7
   end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: sitemap.add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  # 
  # 
  # Examples:
  # 
  # Add '/articles'
  #   
  #   sitemap.add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add individual articles:
  #
  #   Article.find_each do |article|
  #     sitemap.add article_path(article), :lastmod => article.updated_at
  #   end
end