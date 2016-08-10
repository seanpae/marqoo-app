class AddLikeCountToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :likes_count, :string 
  end
end
