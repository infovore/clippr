class Chunk
  attr_reader :title, :author, :details, :content

  def initialize(chunk_string)
    lines = chunk_string.split("\n")
    title_and_author = lines.shift

    @title, @author = dechunk_title_and_author(title_and_author)

    @details = parse_details(lines.shift)

    lines.shift
    @content = lines.join
  end

  def method_missing(m, *args, &block)
    # keeps all the details on the details objects, but delegates up.
    if @details && @details.has_key?(m.to_sym)
      @details[m.to_sym]
    else
      super
    end
  end

  def is_note
    @details && details[:is_note]
  end

  def is_highlight
    @details && details[:is_highlight]
  end

  def self.new_from_raw(raw_chunks)
    raw_chunks.map {|c| Chunk.new(c)}
  end

  private

  def dechunk_title_and_author(title_and_author)
    # this needs to be sorted - add a "No Author" user on import.
    if title_and_author.match(/\((.+)\)/)
      author = title_and_author.match(/\((.+)\)/)[1]
    else
      author = nil
    end
    title = title_and_author.gsub(" (#{author})", "").strip

    [title, author]
  end

  def location_string_to_array(locations)
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

  def datetime_from_string(datetime_string)
    datetime_string = datetime_string.gsub("Added on ", "").strip
    datetime = Time.parse(datetime_string)
  end

  def parse_details(details)
    detail_fragments = details.split("|")
    if detail_fragments.size == 3 # recently changed this from details.size. Check!
      parse_detail({:page => detail_fragments[0],
                    :location => detail_fragments[1],
                    :datetime => detail_fragments[2]})
    else
      parse_detail({:page => nil,
                    :location => detail_fragments[0],
                    :datetime => detail_fragments[1]})
    end
  end

  def parse_detail(detail)
    puts self.inspect
    if (detail[:page] && detail[:page].match("Note")) || detail[:location].match("Note")
      parse_note(detail)
    elsif (detail[:page] && detail[:page].match("Highlight")) || detail[:location].match("Highlight")
      parse_highlight(detail)
    end
  end

  def parse_note(detail)
    page, location = nil, nil
    if detail[:page]
      page = detail[:page].gsub(/\D/,"").to_i
    else
      location = detail[:location].gsub('- Note Loc. ', "").strip.to_i
    end

    {:is_note => true,
     :is_highlight => false,
     :page => page,
     :location => location,
     :clipped_at => datetime_from_string(detail[:datetime])}
  end

  def parse_highlight(detail)
    page, start_loc, end_loc = nil, nil, nil

    if detail[:page]
      page = detail[:page].gsub(/\D/,"").to_i
      locations = detail[:location].strip.gsub("Loc. ", "")
      start_loc, end_loc = location_string_to_array(locations)
    else
      locations = detail[:location].gsub('- Highlight Loc. ', "").strip
      start_loc, end_loc = location_string_to_array(locations)
    end

    {:page => page,
     :start_loc => start_loc,
     :end_loc => end_loc,
     :is_highlight => true,
     :is_note => false,
     :clipped_at => datetime_from_string(detail[:datetime])}
  end
end