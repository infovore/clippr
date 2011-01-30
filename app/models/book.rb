class Book < ActiveRecord::Base
  belongs_to :author
  has_many :clippings
  has_many :notes
  
  def clippings_and_notes
    items = clippings + notes
    items = items.sort_by {|i| i.loc}
    items
  end
end
