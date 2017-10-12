require 'dotenv'
require 'nokogiri'
require 'open-uri'
require 'sinatra'
require 'sinatra/reloader'

class Teamparse

  def initialize
    Dotenv.load
  end

  def teamurl
    "#{ENV['TEAM_URL']}"
  end

  def teamparse
    Nokogiri::XML(open("#{teamurl}"))
  end

  def items
    teamparse.css('item') #.map { |items| items }
  end

  def teamcategory
    items.css('category').first.text
  end

  # def eachitems
  #   teamparse.css('item').map { |items| items }
  # end
  #
  #
  # def itemparse
  #   items.each do | item |
  #     Nokogiri::XML(item).map { |item| item }
  #   end
  # end

  # def itemsinfo
  #   puts teamcategory.upcase
  #   items.map.each_with_index do |item, index|
  #     @itemtitle = item.css('title').text #.map { |title| title.text }
  #     @itemurl = item.css('link').text #.map { |link| link.text }
  #     @itemid = item.css('guid').text #.map { |link| link.text }
  #     itemcontent = item.xpath('//content:encoded', 'content' => "http://purl.org/rss/1.0/modules/content/").text
  #     @itemframe = Nokogiri::XML(itemcontent).css('iframe').map {|itemsframe| itemsframe.attr('src') } #.map { |itemframe| itemframe }
  #
  #     # puts @itemframe[index]
  #     puts "#{@itemtitle}
  #           #{@itemurl}
  #           #{@itemid}
  #           #{@itemframe[index]}"
  #   end
  # end
  #
  # def itemtitle
  #   items.css('title').map { |title| title.text }
  # end
  #
  # def itemurl
  #   items.css('link').map { |link| link.text }
  # end
  #
  # def itemid
  #   items.css('guid').map { |link| link.text }
  # end
  #
  # def itemframe
  #   itemcontent = items.xpath('//content:encoded', 'content' => "http://purl.org/rss/1.0/modules/content/").text
  #   Nokogiri::XML(itemcontent).css('iframe').map { |itemframe| itemframe.attr('src') }
  # end

end

# puts Teamparse.new.itemsinfo

get '/' do
  @teamcategory = Teamparse.new.teamcategory.upcase
  @items = Teamparse.new.items.map.each_with_index do |item, index|
    @itemcontent = item.xpath('//content:encoded', 'content' => "http://purl.org/rss/1.0/modules/content/").text #.map {|itemcontent| itemcontent.text}
  {
    itemtitle: item.css('title').text, #.map { |title| title.text }
    itemurl: item.css('link').text, #.map { |link| link.text }
    itemid: item.css('guid').text, #.map { |link| link.text }
    itemframe: Nokogiri::XML(@itemcontent).css('iframe').map {|itemframe| itemframe.attr('src')}[index] #.map { |itemframe| itemframe }
  }
  end

  erb :default

end
