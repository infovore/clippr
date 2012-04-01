# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120401211347) do

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", :force => true do |t|
    t.string   "title"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name"
    t.string   "slug"
  end

  create_table "clippings", :force => true do |t|
    t.text     "content"
    t.datetime "clipped_at"
    t.integer  "book_id"
    t.integer  "author_id"
    t.integer  "import_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "start_location"
    t.integer  "end_location"
    t.string   "page"
  end

  create_table "imports", :force => true do |t|
    t.text     "raw_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instapaper_references", :force => true do |t|
    t.integer  "clipping_id"
    t.string   "url"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.integer  "location",            :limit => 255
    t.integer  "book_id"
    t.integer  "author_id"
    t.integer  "import_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "related_clipping_id"
    t.string   "page"
    t.datetime "clipped_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

end
