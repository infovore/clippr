class Clipping < ActiveRecord::Base
  belongs_to :import
  belongs_to :book
  
  def loc
    locations
  end
  
end
