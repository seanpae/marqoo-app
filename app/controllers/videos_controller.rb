class VideosController < ApplicationController
  def index
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id])
    @comments = @video.comments 
  end

  def new
    @video = Video.new
  end
  
end
