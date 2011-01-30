class ClippingsHaveStartAndEndLocs < ActiveRecord::Migration
  def self.up
    add_column :clippings, :start_location, :integer
    add_column :clippings, :end_location, :integer
    remove_column :clippings, :locations
  end

  def self.down
    add_column :clippings, :locations, :string
    remove_column :clippings, :end_location
    remove_column :clippings, :start_location
  end
end
