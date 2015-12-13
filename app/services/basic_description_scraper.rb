require 'open-uri'
require 'open_uri_redirections'

class BasicDescriptionScraper
  def scrape(url)
    url = normalize_url(url)
    source = open(url, allow_redirections: :all).read
    return Readability::Document.new(source, blacklist: %w[img], tags: %w[div p ul li strong h2]).content
  end

  protected
  
  def normalize_url(url)
    ActiveSupport::Inflector.transliterate(url.gsub('https','http'))    
  end  
end
