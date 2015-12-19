require 'open-uri'
require 'open_uri_redirections'

class BasicDescriptionScraper
  def self.scrape(url)
    url = normalize_url(url)
    source = open(url, allow_redirections: :all, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.80 Safari/537.36').read
    readable = Readability::Document.new(source, blacklist: %w[img], tags: %w[div p ul li strong h2]).content
    readable.gsub!(" *", " <br/>*")
    readable.gsub!(/-----*/, "<br><hr><br>")
    readable
  end

  protected
  
  def self.normalize_url(url)
    ActiveSupport::Inflector.transliterate(url.gsub('https','http'))    
  end  
end
