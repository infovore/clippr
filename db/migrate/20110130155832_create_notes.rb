class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.text     "content"
      t.datetime "clipped_at"
      t.string   "location"
      t.integer  "book_id"
      t.integer  "author_id"
      t.integer  "import_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
