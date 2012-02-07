class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string   :type
      t.integer  :assetable_id
      t.string   :assetable_type
      t.string   :attachment_file_name
      t.string   :attachment_content_type
      t.integer  :attachment_file_size
      t.datetime :attachment_updated_at
      t.string   :attachment_subtitle
      t.string   :attachment_width
      t.string   :attachment_height
    end
  end

  def self.down
    drop_table :assets
  end
end

