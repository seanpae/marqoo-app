class AddIndexes < ActiveRecord::Migration
  def change
  	add_index :videos, :user_id
  	add_index :videos, :category_id
  end
end
