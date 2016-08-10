class ModifyCounterCache < ActiveRecord::Migration
  def change
  	remove_column :videos, :likes_count

  	add_column :videos, :likes_count, :integer, :default => 0
  end
end
