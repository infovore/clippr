class Book < ActiveRecord::Base
  belongs_to :author
  has_many :clippings, :dependent => :destroy
  has_many :notes, :dependent => :destroy
end
