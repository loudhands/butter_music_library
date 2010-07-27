class TracksController < ApplicationController
  before_filter :authenticate, :except => [:create, :index]
  before_filter :only => :index do |c|
    c.send(:authenticate) unless c.request.format.rss?
  end
    
  
  def index
    respond_to do |format|
      format.html { @tracks = Track.all.paginate(:per_page => 25, :page => params[:page]) }
      format.rss { render :xml => Track.rss }
    end
    
    if request.xhr?
      sleep(2)
      render :partial => @tracks
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
  
  def edit
    @track = Track.find(params[:id])
  end
  
  def edit_multiple
    @tracks = Track.find(params[:track_ids])
    
    if params[:commit] == "Delete Selected"
      @delete = true
    else
      @delete = false
    end
  end
  
  def update
    @track = Track.find(params[:id])
    if @track.update_attributes(params[:track])
      redirect_to tracks_path
      flash[:notice] = "Track info saved."
    else
      render :action => 'edit'
    end
  end
  
  def update_multiple
    @tracks = Track.find(params[:track_ids])
    @tracks.each do |track|
      track.update_attributes!(params[:track].reject { |k,v| v.blank? })
    end
    flash[:notice] = "Tracks updated."
    redirect_to tracks_path
  end
  
  def destroy
    @track = Track.find(params[:id])
    @track.delete
    redirect_to tracks_path
    flash[:notice] = "Track deleted."
  end
  
  def delete_multiple
    @tracks = Track.find(params[:track_ids])
    if params[:commit] == "Yes"
      @tracks.each do |track|
        track.destroy
      end
      flash[:notice] = "Tracks deleted."
      redirect_to tracks_path
    else
      redirect_to tracks_path
    end
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
