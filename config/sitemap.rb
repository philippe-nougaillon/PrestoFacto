# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.prestofacto.fr"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #

  add pages_a_propos_path
  add pages_guide_path
  add pages_blog_path

  # Add all articles:
  
  # Blog.find_each do |article|
  #   add blog_path(article), :lastmod => article.updated_at
  # end

end
