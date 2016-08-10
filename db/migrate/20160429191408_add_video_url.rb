class AddVideoUrl < ActiveRecord::Migration
  def change
  	add_column :videos, :video_source, :string 
  end
end
