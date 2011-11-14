class RemoveClippedAtFromNotes < ActiveRecord::Migration
  def self.up
    remove_column :notes, :clipped_at
  end

  def self.down
    add_column :notes, :clipped_at, :datetime
  end
end
