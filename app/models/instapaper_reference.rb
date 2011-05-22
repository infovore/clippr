require 'nokogiri'
require 'open-uri'
class InstapaperReference < ActiveRecord::Base
  belongs_to :clipping
  
  def self.find_or_create_from_clipping(clipping)
    if clipping.instapaper_reference
      clipping.instapaper_reference
    else
      ir = self.new
      ir.clipping = clipping
      
      query = URI.escape(clipping.content)
      doc = Nokogiri::HTML(open("http://www.google.com/search?q=#{query}"))

      result = doc.css('h3.r a.l').first

      if result
        ir.url = result.attributes['href']
        ir.title = result.content
        if ir.save
          ir
        end
      else
        nil
      end
    end
  end
end
