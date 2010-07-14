class AddInfoToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :genre, :string
    add_column :tracks, :grouping, :string
    add_column :tracks, :composer, :string
    add_column :tracks, :comments, :text
    add_column :tracks, :album, :string
    add_column :tracks, :artist, :string
  end

  def self.down
    remove_column :tracks, :genre
    remove_column :tracks, :grouping
    remove_column :tracks, :composer
    remove_column :tracks, :comments
    remove_column :tracks, :album
    remove_column :tracks, :artist
  end
end
