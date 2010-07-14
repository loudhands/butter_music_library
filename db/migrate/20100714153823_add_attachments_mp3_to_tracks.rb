class AddAttachmentsMp3ToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :mp3_file_name, :string
    add_column :tracks, :mp3_content_type, :string
    add_column :tracks, :mp3_file_size, :integer
    add_column :tracks, :mp3_updated_at, :datetime
  end

  def self.down
    remove_column :tracks, :mp3_file_name
    remove_column :tracks, :mp3_content_type
    remove_column :tracks, :mp3_file_size
    remove_column :tracks, :mp3_updated_at
  end
end
