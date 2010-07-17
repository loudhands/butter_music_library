require 'spec_helper'
require 'hpricot'

describe Track do
  # TODO: need to test this RSS method better since it's so huge.
  it "should make an RSS feed of all the tracks" do
    Factory(:track)
    doc = Hpricot::XML(Track.rss)
    item = (doc/"item").first
    (item/"title").text.should == Track.first.title
  end
  
  it "should make an itunes description for itself" do
    track = Factory(:track, :genre => "Yee", :grouping => "Haw")
    track.itunes_description.should == "Yee, Haw"
  end
 
end
