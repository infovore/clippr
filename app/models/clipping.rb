class Clipping < ActiveRecord::Base
  belongs_to :import
  belongs_to :book
  has_one :note, :class_name => "Note", :foreign_key => "related_clipping_id"
  
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
      [start_loc.to_i, nil]
    end
  end
  
  def location_string
    if end_location
      "#{start_location}-#{end_location}"
    else
      "#{start_location}"
    end
  end
end
