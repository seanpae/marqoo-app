class AddReportedToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :reported, :boolean, :default => false
  end
end
