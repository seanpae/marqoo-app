class AddThumbnailToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :thumbnail_url, :string 
  end
end
