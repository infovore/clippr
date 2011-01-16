class Import < ActiveRecord::Base
  has_many :clippings
  
  def self.perform_import
    raw_text = File.open(File.join(Rails.root, "data", "My Clippings.txt")).readlines.join.gsub(/\r/, "")
    
    i = Import.new
    i.raw_text = raw_text
    i.save
    
    chunks = raw_text.split("==========\n")
    chunks.pop
    chunks.each do |chunk|
      lines = chunk.split("\n")
      title_and_author = lines.shift
      details = lines.shift
      lines.shift
      content = lines.join
      
      author = title_and_author.match(/\((.+)\)/)[1]
      title = title_and_author.gsub(" (#{author})", "").strip
      
      location,datetime = details.split("|")
      
      location = location.gsub('- Highlight Loc. ', "").strip
      datetime = Time.parse(datetime.gsub("Added on ", "").strip)
      
      author = Author.find_or_create_by_name(author)
      book = Book.find_or_create_by_title_and_author_id(title, author.id)
      
      Clipping.create(:content => content, :clipped_at => datetime, :locations => location, :author_id => author, :book => book, :import => i)
    end
    
  end
end
