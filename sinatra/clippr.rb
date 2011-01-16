require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'haml'

class Clippings
  attr_reader :raw_text
  attr_reader :fragments
  
  def initialize(file="../data/My Clippings.txt")
    @raw_text = File.open(file).readlines.join.gsub(/\r/, "")
    @fragments = find_fragments
  end

  def titles
    @fragments.map {|f| f[:title]}.uniq
  end
  
  def authors
    @fragments.map {|f| f[:author]}.uniq
  end
  
  def titles_and_authors
    @fragments.map {|f| [f[:title], f[:author]]}.uniq
  end
  
  def clippings_for_title(title)
    @fragments.select {|f| f[:title] == title}
  end
  
  private
  
  def find_fragments
    chunks = @raw_text.split("==========\n")
    chunks.pop
    output = []
    chunks.each do |chunk|
      lines = chunk.split("\n")
      title_and_author = lines.shift
      details = lines.shift
      lines.shift
      content = lines.join
      
      author = title_and_author.match(/\((.+)\)/)[1]
      title = title_and_author.gsub(" (#{author})", "").strip
      
      location,datetime = details.split("|")
      
      location = location.gsub('- Highlight Loc. ', "").strip
      datetime = Time.parse(datetime.gsub("Added on ", "").strip)
      
      output << {:title => title, :author => author, :location => location, :datetime => datetime, :content => content}
    end
    output
  end
  
end

get "/" do
  @clippings = Clippings.new
  haml :index
end

get "/books/:title" do
  @clippings = Clippings.new
  @title = params[:title]
  @fragments = @clippings.clippings_for_title(@title)
  haml :book
end