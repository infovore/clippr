class AddDisplayNameToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :display_name, :string
    add_column :books, :slug, :string
  end

  def self.down
    remove_column :books, :display_name
    remove_column :books, :slug
  end
end
