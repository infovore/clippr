require 'nokogiri'
require 'open-uri'
class InstapaperReference < ActiveRecord::Base
  belongs_to :clipping
  
  def self.find_data_for_clipping(clipping)
    query = URI.escape(clipping.content)
    doc = Nokogiri::HTML(open("http://www.google.com/search?q=#{query}"))

    result = doc.css('h3.r a.l').first

    if result
      {:url => result.attributes['href'],
       :title => result.content}
    else
      nil
    end
  end
  
  def self.new_for_clipping(clipping)
    data = find_data_for_clipping(clipping)

    if data
      self.new(:url => data[:url].value,
               :title => data[:title],
               :clipping_id => clipping.id)
    else
      self.new
    end
  end

end
