require 'spec_helper'

describe TracksController do
  before(:each) do
    User.delete_all
    Track.delete_all
    @user = Factory(:user)
    @user.email_confirmed = true
    sign_in_as @user
  end
  
  describe "GET index" do
    before(:each) do
      Track.delete_all
      3.times do
        Factory(:track)
      end
    end
    
    it "should show all the tracks" do
      get :index
      assigns['tracks'].length.should == 3
    end
    
    it "should format RSS" do
      get :index, :format => "rss"
      response.should be_success
    end
    
    it "should let me see the RSS feed even if I'm not logged in" do
      sign_out
      get :index, :format => "rss"
      response.should be_success
    end
  end
  
  describe "GET new" do
    it "should let me upload a track" do
      get :new
      response.should be_success
      assigns['track'].should_not be_nil
    end
  end
  
  # TODO test this better- need to include the coerce thing.
  describe "POST create" do
    it "should let me upload tracks" do
      Track.delete_all
      track = Factory(:track)
      count = Track.count
      post :create, :track => track.attributes
      Track.count.should == count + 1
    end
  end
  
  describe "GET show" do
    it "should show a track" do
      track = Factory(:track)
      get :show, :id => track.id
      assigns['track'].title.should == track.title
      response.should be_success
    end
  end
  
  describe "GET edit" do
    it "should let me edit a track" do
      track = Factory(:track)
      get :edit, :id => track.id
      assigns['track'].title.should == track.title
      response.should be_success
    end
  end
  
  describe "POST edit_multiple" do
    before(:each) do
      2.times do
        Factory(:track)
      end
    end
    
    it "should let me edit multiple tracks at once" do
      post :edit_multiple, :track_ids => [Track.first.id, Track.last.id], :commit => "Group Edit Selected"
      assigns['tracks'].first.should == Track.first
      assigns['tracks'].last.should == Track.last
      assigns['delete'].should be_false
      
    end
    
    it "should let me delete multiple tracks at once" do
      post :edit_multiple, :track_ids => [Track.first.id, Track.last.id], :commit => "Delete Selected"
      assigns['tracks'].first.should == Track.first
      assigns['tracks'].last.should == Track.last
      assigns['delete'].should be_true
    end
  end
  
  describe "PUT update" do
    it "should update the attributes of a track" do
      track = Factory(:track)
      put :update, :track => {:title => "New Title"}, :id => track.id
      Track.find(track.id).title.should == "New Title"
      response.should redirect_to(tracks_path)
      flash[:notice].should == "Track info saved."
    end
  end
  
  describe "PUT update_multiple" do
    it "should let me update the attributes of multiple tracks at once" do
      2.times do
        Factory(:track)
      end
      
      put :update_multiple, :track_ids => [Track.first.id, Track.last.id], :track => {:genre => "Quirky"}
      assigns['tracks'].first.should == Track.first
      assigns['tracks'].last.should == Track.last
      Track.first.genre.should == "Quirky"
      Track.last.genre.should == "Quirky"
      response.should redirect_to(tracks_path)
      flash[:notice].should == "Tracks updated."
    end
  end
  
  describe "DELETE destroy" do
    it "should let me delete a track" do
      track = Factory(:track)
      count = Track.count
      delete :destroy, :id => track.id
      response.should redirect_to(tracks_path)
      flash[:notice].should == "Track deleted."
      Track.count.should == count - 1
    end
  end
  
  describe "DELETE delete_multiple" do
    before(:each) do
      2.times do
        Factory(:track)
      end
    end
    
    it "should let me delete multiple tracks at once" do
      delete :delete_multiple, :track_ids => [Track.first.id, Track.last.id], :commit => "Yes"
      Track.count.should == 0
      response.should redirect_to(tracks_path)
      flash[:notice].should == "Tracks deleted."
    end
    
    it "should take me back to the index and do nothing if I click 'No'" do
      delete :delete_multiple, :track_ids => [Track.first.id, Track.last.id], :commit => "No"
      Track.count.should == 2
      response.should redirect_to(tracks_path)
    end
  end
  
end
