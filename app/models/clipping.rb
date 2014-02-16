class Clipping < ActiveRecord::Base
  belongs_to :import
  belongs_to :book
  has_one :note, :class_name => "Note", :foreign_key => "related_clipping_id"
  has_one :instapaper_reference

  def author
    book.author
  end

  def loc
    start_location
  end

  def self.create_from_chunk_for_import(chunk, import)
    author_obj = Author.find_or_create_by_name(chunk.author)
    book_obj = Book.find_or_create_by_title_and_author_id(chunk.title, author_obj.id)
    self.create(:content => chunk.content,
                :clipped_at => chunk.clipped_at,
                :start_location => chunk.start_loc,
                :end_location => chunk.end_loc,
                :page => chunk.page,
                :author_id => author_obj.id,
                :book_id => book_obj.id,
                :import_id => import.id)
  end
  
  def self.find_related_clipping(location)
    Clipping.first(:conditions => ["start_location <= ? AND end_location >= ?", location, location])
  end
  
  def location_string
    if single_location?
      "#{start_location}"
    else
      "#{start_location}-#{end_location}"
    end
  end
  
  def single_location?
    start_location == end_location
  end

  def zero_location?
    # ie it's come from a PDF, which has no locations.
    start_location == 0 && end_location == 0
  end

  def is_pdf?
    zero_location?
  end

  def instapaper?
    #this should probably be based on hardwired ID, not a string.
    author.name == "Instapaper"
  end
  
  def to_xml(options={})
    super({:except => ['import_id', 'id', 'author_id','book_id', 'created_at','updated_at', 'title'],
          :include => {:instapaper_reference => {}, :note => {}, :book => {:include => :author}}}.merge(options))
  end

  def to_json(options={})
    super
  end

  def to_templated_html(template)
    output = template.gsub("$quote", self.content)
    output = output.gsub("$locations", "Locations: " + self.location_string)
    if self.note
      output = output.gsub("$ifnote", "").gsub("$endifnote", "")
      output = output.gsub("$note", self.note.content)
    else
      output = output.gsub(/(\$ifnote).+(\$endifnote)/, "")
    end
  end
end
