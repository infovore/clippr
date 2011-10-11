class Book < ActiveRecord::Base
  belongs_to :author
  has_many :clippings, :dependent => :destroy
  has_many :notes, :dependent => :destroy
  has_one :book_name, :dependent => :destroy

  acts_as_url :display_name, :url_attribute => :slug, :sync_url => true

  def to_param
    slug
  end

end
