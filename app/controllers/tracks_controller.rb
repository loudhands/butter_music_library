class TracksController < ApplicationController
  def index
    respond_to do |format|
      format.html { @tracks = Track.all }
      format.rss { render :xml => Track.rss }
    end
  end

  def new
    @track = Track.new
  end
  
  def create
    newparams = coerce(params)
    @track = Track.new(newparams[:track])
    if @track.save
      flash[:notice] = "Successfully created upload."
      respond_to do |format|
        format.html {redirect_to tracks_path}
        format.json {render :json => { :result => 'success', :track => track_path(@track) } }
      end
    else
      render :action => 'new'
    end
  end

  def show
    @track = Track.find(params[:id])
  end
  
  private
  
  def coerce(params)
    if params[:track].nil?
      h = Hash.new
      h[:track] = Hash.new
      h[:track][:mp3] = params[:Filedata]
      h[:track][:mp3].content_type = MIME::Types.type_for(h[:track][:mp3].original_filename).to_s
      h
    else
      params
    end
  end

end
