require 'mp3info'
require 'rss/2.0'
require 'rss/itunes'
require 'mime/types'

class Track < ActiveRecord::Base
  acts_as_solr
  
  has_attached_file :mp3, :storage => :s3, 
                          :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                          :path => ':attachment/:id/:basename.:extension',
                          :bucket => 'butter'
  
  before_create :get_meta
  
  # Grab the metadata and store it in the DB so we can edit it later.
  def get_meta
    unless RAILS_ENV == "test"
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
  
  # Make XML for a podcast.
  def self.rss
    rss = RSS::Rss.new("2.0")
    channel = RSS::Rss::Channel.new
    
    category = RSS::ITunesChannelModel::ITunesCategory.new("Arts")
    channel.itunes_categories << category
    
    channel.title = "Butter Music Library"
    channel.description = "The music library of Butter Music and Sound"
    channel.link = "http://gimmebuttertracks.com"
    channel.language = "en-us"
    channel.itunes_subtitle = "Streaming updates from Butter's music library."
    
    Track.find(:all).each do |track|
      item = RSS::Rss::Channel::Item.new
      item.title = track.title
      item.link = track.mp3.url
      
      item.guid = RSS::Rss::Channel::Item::Guid.new
      item.guid.content = track.mp3.url
      item.guid.isPermaLink = true
      
      item.itunes_summary = track.itunes_description
      item.itunes_explicit = "No"
      
      item.enclosure = RSS::Rss::Channel::Item::Enclosure.new(item.link, track.mp3_file_size, 'audio/mpeg')
      channel.items << item
    end
    
    rss.channel = channel
    return rss.to_s
  end
  
  # Sticking genre and grouping in the Podcast description field.
  def itunes_description
    "#{self.genre}, #{self.grouping}"
  end
end
