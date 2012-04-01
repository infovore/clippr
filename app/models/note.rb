class Note < ActiveRecord::Base
  belongs_to :import
  belongs_to :book
  belongs_to :related_clipping, :class_name => "Clipping"
  
  def loc
    location
  end

  def self.create_from_chunk_for_import(chunk, import)
    author_obj = Author.find_or_create_by_name(chunk.author)
    book_obj = Book.find_or_create_by_title_and_author_id(chunk.title, author_obj.id)
    self.create(:content => chunk.content,
                :location => chunk.location,
                :page => chunk.page,
                :author_id => author_obj.id,
                :book => book_obj,
                :import => import,
                :related_clipping => Clipping.find_related_clipping(chunk.location))
  end
  
end
