require 'open-uri'
require 'open_uri_redirections'

class BasicDescriptionScraper
  def self.scrape(url,tags,strip_css=[])
    url = normalize_url(url)
    source = open(url, allow_redirections: :all, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.80 Safari/537.36').read
    html = strip_css(source, strip_css)    
    readable = Readability::Document.new(html, tags: tags).content
    readable.gsub!(" *", " <br/>*")
    readable.gsub!(/-----*/, "<br><hr><br>")
    readable
  end

  protected
  
  def self.normalize_url(url)
    ActiveSupport::Inflector.transliterate(url.gsub('https','http'))    
  end

  def self.strip_css(html,strip_css)
    doc = Nokogiri::HTML(html)
    strip_css.each do |css|      
      doc.search(css) { |src| src.remove }
    end
    doc.to_html
  end
end
