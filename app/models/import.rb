class Import < ActiveRecord::Base
  has_many :clippings
  
  def self.perform_import_from_file(file)
    raw_text = File.open(file).readlines.join.gsub(/\r/, "")
    Import.perform_import_from_raw_text(raw_text)
  end

  def self.perform_import_from_raw_text(raw_text)
    import = Import.new
    import.raw_text = raw_text
    import.save

    # let's store that file anyhow
    File.open(File.join(Rails.root, "data", Time.now.strftime("%Y%m%d%H%M%S") + ".txt"), "w") do |f|
      f << raw_text
    end

    # now let's turn the kindle file into lots of chunks
    chunks = ClippingProcessor.process(raw_text)
    
    # now let's walk that and find new items.
    # this method returns the number of new items it found.
    create_new_items_for_import_from_processed_chunks(chunks, import)
  end
  
  private

  def self.create_new_items_for_import_from_processed_chunks(chunks, import)
    new_items_count = 0
    chunks.each do |chunk|
      author_obj = Author.find_or_create_by_name(chunk.author)
      book_obj = Book.find_or_create_by_title_and_author_id(chunk.title, author_obj.id)
      if chunk.is_note
        unless Note.first(:conditions => {:content => chunk.content, :clipped_at => chunk.clipped_at})
          note = Note.create(:content => chunk.content,
                      :location => chunk.location,
                      :page => chunk.page
                      :author_id => author_obj.id,
                      :book => book_obj,
                      :import => import,
                      :related_clipping => Clipping.find_related_clipping(chunk.location))
          new_items_count += 1
        end
      elsif chunk.is_highlight
        unless Clipping.first(:conditions => {:content => chunk.content, :clipped_at => chunk.clipped_at})
          clipping = Clipping.create(:content => chunk.content,
                          :clipped_at => chunk.clipped_at,
                          :start_location => chunk.start_loc,
                          :end_location => chunk.end_loc,
                          :page => chunk.page,
                          :author_id => author_obj.id,
                          :book => book_obj,
                          :import => import)
          new_items_count += 1
        end
      end
    end
    new_items_count
  end

end
