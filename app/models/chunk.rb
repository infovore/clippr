class Chunk
  include ChunkProcessor
  attr_reader :title, :author, :details, :content, :processed

  def initialize(chunk_string)
    @lines = chunk_string.split("\n")
    @processed = false
  end

  def process
    @title, @author = dechunk_title_and_author(@lines[0])
    @details = parse_details(@lines[1])

    @content = @lines[3..@lines.size].join if @lines[3..@lines.size]
    @processed = true
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
    @details && @details[:is_note]
  end

  def is_highlight
    @details && @details[:is_highlight]
  end

  def self.create_from_raw_text(raw_text)
    raw_chunks = raw_text.gsub("\r", "").split("==========\n")
    self.create_from_raw_chunks(raw_chunks)
  end

  def self.create_from_raw_chunks(raw_chunks)
    raw_chunks.map {|c| Chunk.new(c)}
  end

end