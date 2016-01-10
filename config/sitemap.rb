require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'https://www.remotelyawesomejobs.com'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
                                                                    aws_access_key_id: ENV['RA_AWS_ACCESS_KEY_ID'],
                                                                    aws_secret_access_key: ENV['RA_AWS_SECRET_ACCESS_KEY'],
                                                                    fog_directory: 's3.remotelyawesomejobs.com',
                                                                    fog_region: 'us-east-1')

SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_host = "http://s3.remotelyawesomejobs.com.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

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
