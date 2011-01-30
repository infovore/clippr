class Note < ActiveRecord::Base
  belongs_to :import
  belongs_to :book
  
  def loc
    location
  end
  
end
