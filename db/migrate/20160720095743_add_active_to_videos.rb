class AddActiveToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :active, :boolean, :default => true
  end
end
