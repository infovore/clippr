class KindleImporter
  def self.process(input_text)
    chunks = input_text.gsub("\r", "").split("==========\n")
    output = chunks.map do |chunk|
      title_and_author, details, content = split_up_chunk(chunk)
      
      title,author = dechunk_title_and_author(title_and_author)
      details_hash = parse_details(details)

      {:title => title, 
       :author => author,
       :content => content}.merge(details_hash)
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

  def self.split_up_chunk(chunk)
    lines = chunk.split("\n")
    title_and_author = lines.shift
    details = lines.shift
    lines.shift
    content = lines.join
    [title_and_author,details,content]
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

  def self.parse_details(details)
    if details.scan("|").size == 2 # we have the new 2-item kind of matching
      page,location,datetime_string = details.split("|")
      if page.match("Note")
        # TODO: NO IDEA WHAT TO DO HERE.
        {:puzzled => true,
         :is_note => true}
      elsif page.match("Highlight")
        page = page.gsub(/\D/,"").to_i
        locations = location.strip.gsub("Loc. ", "")
        start_loc, end_loc = location_string_to_array(locations)

        {:page => page,
         :start_loc => start_loc,
         :end_loc => end_loc,
         :is_highlight => true,
         :clipped_at => datetime_from_string(datetime_string)}
      else
        {:oops => true}
      end
    else
      location,datetime_string = details.split("|")
      if location.match("Note")
        is_note = true
        location = location.gsub('- Note Loc. ', "").strip.to_i
        start_loc,end_loc = location, location

        {:start_loc => start_loc,
         :end_loc => end_loc,
         :is_note => true,
         :clipped_at => datetime_from_string(datetime_string)}
      elsif location.match("Highlight") # thus ignoring bookmarks.
        locations = location.gsub('- Highlight Loc. ', "").strip
        start_loc, end_loc = location_string_to_array(locations)

        {:start_loc => start_loc,
         :end_loc => end_loc,
         :is_highlight => true,
         :clipped_at => datetime_from_string(datetime_string)}
      else
        {:oops => true}
      end
    end
  end

end
