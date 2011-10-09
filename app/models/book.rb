class Book < ActiveRecord::Base
  belongs_to :author
  has_many :clippings, :dependent => :destroy
  has_many :notes, :dependent => :destroy
  has_one :book_name, :dependent => :destroy

  def after_create
    BookName.create(:book => self, :display_name => self.title)
  end

  def to_param
    book_name.slug
  end
end
