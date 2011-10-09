class CreateBookNames < ActiveRecord::Migration
  def self.up
    create_table :book_names do |t|
      t.string :display_name
      t.string :slug
      t.integer :book_id
      t.timestamps
    end
  end

  def self.down
    drop_table :book_names
  end
end
