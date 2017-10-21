require 'dotenv'
require 'nokogiri'
require 'open-uri'
require 'sinatra'
require 'sinatra/reloader'

configure {
  set :server, :puma
}


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

end

class Pumatra < Sinatra::Base
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
end
