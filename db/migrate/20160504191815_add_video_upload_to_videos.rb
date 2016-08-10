class AddVideoUploadToVideos < ActiveRecord::Migration
  def up
    add_attachment :videos, :video
  end

  def down
    remove_attachment :vieos, :video
  end
end
