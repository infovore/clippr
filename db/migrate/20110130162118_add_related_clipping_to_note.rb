class AddRelatedClippingToNote < ActiveRecord::Migration
  def self.up
    add_column :notes, :related_clipping_id, :integer
  end

  def self.down
    remove_column :notes, :related_clipping_id
  end
end