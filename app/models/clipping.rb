class Clipping < ActiveRecord::Base
  belongs_to :import
  belongs_to :book
  has_one :note, :class_name => "Note", :foreign_key => "related_clipping_id"
  has_one :instapaper_reference

  def author
    book.author
  end

  def loc
    start_location
  end
  
  def self.location_string_to_array(locations)
    start_loc, end_string = locations.split("-")
    if end_string
      i = start_loc.size - end_string.size - 1
      prefix = start_loc[0..i]
      end_loc = prefix + end_string
      [start_loc.to_i, end_loc.to_i]
    else
      [start_loc.to_i, start_loc.to_i]
    end
  end

  def self.find_related_clipping(location)
    Clipping.first(:conditions => ["start_location <= ? AND end_location >= ?", location, location])
  end
  
  def location_string
    if single_location?
      "#{start_location}"
    else
      "#{start_location}-#{end_location}"
    end
  end
  
  def single_location?
    start_location == end_location
  end

  def instapaper?
    #this should probably be based on hardwired ID, not a string.
    author.name == "Instapaper"
  end
end
