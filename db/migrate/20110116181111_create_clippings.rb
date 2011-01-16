class CreateClippings < ActiveRecord::Migration
  def self.up
    create_table :clippings do |t|
      t.text :content
      t.datetime :clipped_at
      t.string :locations
      t.integer :book_id
      t.integer :author_id
      t.integer :import_id
      t.timestamps
    end
  end

  def self.down
    drop_table :clippings
  end
end
