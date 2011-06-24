class CreateInstapaperReferences < ActiveRecord::Migration
  def self.up
    create_table :instapaper_references do |t|
      t.integer :clipping_id
      t.string :url
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :instapaper_references
  end
end
