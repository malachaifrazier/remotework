class LinkShorteningService
  CHARSET = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a

  def initialize(persist = ShortenedLink)
    @persist = persist
  end

  def short_url(long_url)
    shortened_link = @persist.find_or_create_by!(long: long_url) do |s|
      s.short = (0...6).map{ CHARSET[rand(CHARSET.size)] }.join
    end
    shortened_link.short
  end
  
  def long_url(short_url)
    @persist.find_by(short: short_url).try(:long)
  end
end
