class Book < ActiveRecord::Base
  belongs_to :author
  has_many :clippings, :dependent => :destroy
  has_many :notes, :dependent => :destroy

  acts_as_url :display_name, :url_attribute => :slug, :sync_url => true

  after_create :populate_display_name

  def to_param
    slug
  end

  private

  def populate_display_name
    self.display_name = self.title
    self.save
  end

end
