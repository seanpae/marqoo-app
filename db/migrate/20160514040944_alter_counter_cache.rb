class AlterCounterCache < ActiveRecord::Migration
  def change
  	remove_column :videos, :likes_count, :string
  	add_column :videos, :likes_count, :integer
  end
end
