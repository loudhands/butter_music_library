require 'mp3info'
require 'rss/2.0'
require 'rss/itunes'
require 'mime/types'
require 'solr_pagination'
require 'cgi'

class Track < ActiveRecord::Base
  has_attached_file :mp3, :storage => :s3, 
                          :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                          :path => ':attachment/:id/:basename.:extension'
  
  before_create :get_meta
  
  default_scope :order => 'title'
  
  # Sticking Solr in after paperclip because the reverse causes problems...
  acts_as_solr
  
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
  
  # Solr search with pagination.
  def self.search(search, page)
    if search.blank?
      paginate :page => page, :per_page => 20
    else
      paginate_search(search, page, 20)
    end
  end
  
  # Make XML for a podcast.
  def self.rss
    rss = RSS::Rss.new("2.0")
    channel = RSS::Rss::Channel.new
    
    category = RSS::ITunesChannelModel::ITunesCategory.new("Arts")
    channel.itunes_categories << category
    
    channel.title = "Butter Music and Sound"
    channel.description = "The music library of Butter Music and Sound."
    channel.link = "http://gimmebuttertracks.com"
    channel.language = "en-us"
    channel.itunes_subtitle = "Streaming updates from Butter's music library."
    channel.itunes_author = "Butter Music and Sound"
    
    channel.image = RSS::Rss::Channel::Image.new
    channel.image.url = "http://gimmebuttertracks.com/images/Butter-Album.jpg"
    channel.itunes_image = RSS::ITunesChannelModel::ITunesImage.new("http://gimmebuttertracks.com/images/Butter-Album.jpg")
    
    channel.itunes_owner = RSS::ITunesChannelModel::ITunesOwner.new
    channel.itunes_owner.itunes_name = "Butter Music and Sound"
    channel.itunes_owner.itunes_email = "ian@gimmebutter.com"
    channel.itunes_explicit = "No"
    
    Track.find(:all).each do |track|
      item = RSS::Rss::Channel::Item.new
      item.title = track.title
      item.link = track.itunes_filename
      
      item.guid = RSS::Rss::Channel::Item::Guid.new
      item.guid.content = track.itunes_filename
      item.guid.isPermaLink = true
      
      item.itunes_summary = track.itunes_description
      item.itunes_explicit = "No"
      item.itunes_author = "Butter Music and Sound"
      
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
  
  # Need to CGI escape any tracks with spaces in the name or the RSS feed won't validate.
  def itunes_filename
    case RAILS_ENV
    when "test"
      self.mp3.url
    when "development"
      "http://s3.amazonaws.com/butter_music_library_development/#{CGI.escape(self.mp3.path)}"
    else
      "http://s3.amazonaws.com/butter_music_library/#{CGI.escape(self.mp3.path)}"
    end
  end
end
