class Author < ActiveRecord::Base
  has_many :books
  has_many :clippings, :through => :books
end
