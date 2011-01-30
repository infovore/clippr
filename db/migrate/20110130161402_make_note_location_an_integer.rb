class MakeNoteLocationAnInteger < ActiveRecord::Migration
  def self.up
    change_column :notes, :location, :integer
  end

  def self.down
    change_column :notes, :location, :string
  end
end