class Note < ActiveRecord::Base
  belongs_to :import
  belongs_to :book
  belongs_to :related_clipping, :class_name => "Clipping"
  
  def loc
    location
  end
  
end
