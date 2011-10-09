class BookName < ActiveRecord::Base
  belongs_to :book

  acts_as_url :display_name, :url_attribute => :slug, :sync_url => true
end
