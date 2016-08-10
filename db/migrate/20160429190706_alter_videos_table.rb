class AlterVideosTable < ActiveRecord::Migration
  def change
  	remove_column :videos, :source
  end
end
