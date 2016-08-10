class PagesController < ApplicationController
  def index
  	@videos = Video.limit(8).order("RANDOM()")
  end
  def privacy
  end
  def terms
  end
  def contact
  end
end
