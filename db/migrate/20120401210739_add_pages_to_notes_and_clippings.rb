class AddPagesToNotesAndClippings < ActiveRecord::Migration
  def self.up
    add_column :clippings, :page, :string
    add_column :notes, :page, :string
  end

  def self.down
    remove_column :clippings, :page
    remove_column :notes, :page
  end
end
