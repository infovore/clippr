class Book < ActiveRecord::Base
  belongs_to :author
  has_many :clippings
  has_many :notes
  
end
