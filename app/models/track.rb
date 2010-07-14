require 'mp3info'

class Track < ActiveRecord::Base
  has_attached_file :mp3, :storage => :s3, 
                          :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                          :path => ':attachment/:id/:basename.:extension',
                          :bucket => 'butter_test'
  
  before_save :get_meta
  
  # Grab the metadata and store it in the DB so we can edit it later.
  def get_meta
    Mp3Info.open(mp3.to_file.path) do |song|
      self.title = song.tag2.TT2
      self.composer = song.tag2.TCM
      self.grouping = song.tag2.TT1
      self.genre = song.tag.genre_s
      self.album = song.tag2.TAL
      self.comments = song.tag.comments
      self.artist = song.tag.artist
    end
  end
end
