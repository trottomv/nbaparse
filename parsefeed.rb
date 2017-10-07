require 'nokogiri'
require 'open-uri'
require 'date'

class HRparse
  # def url
  #   url = "http://tvrex.net/"
  # end

  def rocketsurl
    "http://tvrex.net/category/nba/houston-rockets/"
  end

  def rocketsparse
    Nokogiri::HTML(open("#{rocketsurl}"))
  end

  def itemurl
    rocketsparse.css('h2 a').map { |link| link['href'] }
  end

  def itemframe
    itemurl.map { | itemurl |
      Nokogiri::HTML(open("#{itemurl}")).css('iframe').attr('src').value
    }.each do | itemframe |
    end
  end

end

# puts HRparse.new.itemframe
