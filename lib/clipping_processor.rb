class ClippingProcessor
  def self.process(raw_text)
    raw_chunks = raw_text.gsub("\r", "").split("==========\n")
    Chunk.new_from_raw(raw_chunks)
  end
end
