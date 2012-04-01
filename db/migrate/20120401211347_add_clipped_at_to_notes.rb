class AddClippedAtToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :clipped_at, :datetime
  end

  def self.down
    remove_column :notes, :clipped_at
  end
end
