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

  def allurl
    "#{ENV['ALL_URL']}"
  end

  def teamparse
    Nokogiri::XML(open("#{teamurl}"))
  end

  def allparse
    Nokogiri::XML(open("#{allurl}"))
  end

  def items
    teamparse.css('item') #.map { |items| items }
  end

  def allitems
    allparse.css('item') #.map { |items| items }
  end

  def teamcategory
    items.css('category').first.text
  end

end

configure {
  set :server, :puma
}

get '/' do
  #@teamcategory = Teamparse.new.teamcategory.upcase
  erb :default
end

get '/all' do
  @teamcategory = Teamparse.new.teamcategory.upcase
  @items = Teamparse.new.allitems.map.each_with_index do |item, index|
    @itemcontent = item.xpath('//content:encoded', 'content' => "http://purl.org/rss/1.0/modules/content/").text #.map {|itemcontent| itemcontent.text}
    {
      itemtitle: item.css('title').text, #.map { |title| title.text }
      itemurl: item.css('link').text, #.map { |link| link.text }
      itemid: item.css('guid').text, #.map { |link| link.text }
      itemframe: Nokogiri::XML(@itemcontent).css('iframe').map {|itemframe| itemframe.attr('src')}[index] #.map { |item| item }}
    }
    end

  erb :all
end

get '/hr' do
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

  erb :hr
end

post '/' do
  pick_team = params[:pick_team]

  @your_choice = YourChoice.new(pick_team)
  redirect '/to_a_page'
end

