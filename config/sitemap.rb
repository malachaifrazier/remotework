require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'https://www.remotelyawesomejobs.com'
SitemapGenerator::Sitemap.create do
  add '/', :changefreq => 'daily'
  add '/about', :changefreq => 'weekly'
  add '/why', :changefreq => 'weekly'

  Job.posted.each do |job|
    add job_path(job)
  end

  add tag_path('ruby-on-rails')
  add tag_path('django')
  add tag_path('python')
  add tag_path('objective-c')
  add tag_path('java')
  add tag_path('javascript')
  add tag_path('php')
  add tag_path('design')
end
