require 'dotenv'
require 'nokogiri'
require 'open-uri'
require 'date'


class HRparse

  def initialize
    Dotenv.load
  end

  def teamurl
    "#{ENV['TEAM_URL']}"
  end

  def teamparse
    Nokogiri::HTML(open("#{teamurl}"))
  end

  def itemtitle
    teamparse.css('h2 a').map { |title| title.text }
  end

  def itemurl
    teamparse.css('h2 a').map { |link| link['href'] }
  end

  def itemframe
    itemurl.map { | itemurl |
      Nokogiri::HTML(open("#{itemurl}")).css('iframe').attr('src').value
    }.each do | itemframe |
    end
  end

end

# puts "#{HRparse.new.itemtitle} #{HRparse.new.itemframe}"
# puts HRparse.new.itemtitle
# puts HRparse.new.itemframe
