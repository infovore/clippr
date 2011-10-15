class Import < ActiveRecord::Base
  has_many :clippings
  
  def self.perform_import_from_file(file)
    raw_text = File.open(file).readlines.join.gsub(/\r/, "")
    Import.perform_import_from_raw_text(raw_text)
  end
  
  def self.perform_import_from_raw_text(raw_text)
    i = Import.new
    i.raw_text = raw_text
    i.save
    
    # let's store that file anyhow
    File.open(File.join(Rails.root, "data", Time.now.strftime("%Y%m%d%H%M%S") + ".txt"), "w") do |f|
      f << raw_text
    end

    chunks = raw_text.gsub("\r", "").split("==========\n")
    chunks.each do |chunk|
      lines = chunk.split("\n")
      title_and_author = lines.shift
      details = lines.shift
      lines.shift
      content = lines.join
      
      # this needs to be sorted - add a "No Author" user on import.
      if title_and_author.match(/\((.+)\)/)
        author = title_and_author.match(/\((.+)\)/)[1]
      else
        author = nil
      end
      title = title_and_author.gsub(" (#{author})", "").strip
      
      author = Author.find_or_create_by_name(author)
      book = Book.find_or_create_by_title_and_author_id(title, author.id)
      
      is_note = false 
      is_highlight = false

      if details.scan("|").size == 2 # we have the new 2-item kind of matching
        page,location,datetime_string = details.split("|")
        if page.match("Note")
          is_note = true
          # NO IDEA WHAT TO DO HERE.
        elsif page.match("Highlight")
          is_highlight = true
          locations = location.strip.gsub("Loc. ", "")
          start_loc, end_loc = Clipping.location_string_to_array(locations)
        end
      else
        location,datetime_string = details.split("|")
        page = nil
        if location.match("note")
          is_note = true
          location = location.gsub('- Note Loc. ', "").strip.to_i
          related_clipping = Clipping.find_related_clipping(location)
        elsif location.match("Highlight") # thus ignoring bookmarks.
          locations = location.gsub('- Highlight Loc. ', "").strip
          start_loc, end_loc = Clipping.location_string_to_array(locations)
        end
      end

      datetime_string = datetime_string.gsub("Added on ", "").strip
      datetime = Time.parse(datetime_string)

      if is_note
        unless Note.first(:conditions => {:content => content, :clipped_at => datetime})
          Note.create(:content => content,
                      :clipped_at => datetime,
                      :location => location,
                      :author_id => author,
                      :book => book,
                      :import => i,
                      :related_clipping => related_clipping)
        end
      elsif is_highlight
        unless Clipping.first(:conditions => {:content => content, :clipped_at => datetime})
          Clipping.create(:content => content,
                          :clipped_at => datetime,
                          :start_location => start_loc,
                          :end_location => end_loc,
                          :author_id => author,
                          :book => book,
                          :import => i)
        end
      end
    end
    
  end
end
