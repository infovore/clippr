class KindleImporter
  def self.process(input_text)
    chunks = input_text.gsub("\r", "").split("==========\n")
    output = chunks.map do |chunk|
      lines = chunk.split("\n")
      title_and_author = lines.shift
      details = lines.shift
      lines.shift
      content = lines.join
      
      title,author = dechunk_title_and_author(title_and_author)
      
      is_note = false 
      is_highlight = false

      if details.scan("|").size == 2 # we have the new 2-item kind of matching
        page,location,datetime_string = details.split("|")
        if page.match("Note")
          is_note = true
          # TODO: NO IDEA WHAT TO DO HERE.
        elsif page.match("Highlight")
          is_highlight = true
          page = page.gsub(/\D/,"").to_i
          locations = location.strip.gsub("Loc. ", "")
          start_loc, end_loc = location_string_to_array(locations)
        end
      else
        location,datetime_string = details.split("|")
        page = nil
        if location.match("Note")
          is_note = true
          location = location.gsub('- Note Loc. ', "").strip.to_i
          start_loc,end_loc = location, location
          #related_clipping = Clipping.find_related_clipping(location)
        elsif location.match("Highlight") # thus ignoring bookmarks.
          is_highlight = true
          locations = location.gsub('- Highlight Loc. ', "").strip
          start_loc, end_loc = location_string_to_array(locations)
        end
      end

      datetime = datetime_from_string(datetime_string)

      {:title => title, 
       :author => author,
       :content => content,
       :is_highlight => is_highlight,
       :is_note => is_note,
       :start_loc => start_loc,
       :end_loc => end_loc,
       :clipped_at => datetime,
       :page => page}
    end
    output
  end

  private

  def self.location_string_to_array(locations)
    start_loc, end_string = locations.split("-")
    if end_string
      i = start_loc.size - end_string.size - 1
      prefix = start_loc[0..i]
      end_loc = prefix + end_string
      [start_loc.to_i, end_loc.to_i]
    else
      [start_loc.to_i, start_loc.to_i]
    end
  end
  
  def self.dechunk_title_and_author(title_and_author)
    # this needs to be sorted - add a "No Author" user on import.
    if title_and_author.match(/\((.+)\)/)
      author = title_and_author.match(/\((.+)\)/)[1]
    else
      author = nil
    end
    title = title_and_author.gsub(" (#{author})", "").strip

    [title,author]
  end

  def self.datetime_from_string(datetime_string)
    datetime_string = datetime_string.gsub("Added on ", "").strip
    datetime = Time.parse(datetime_string)
  end

end
