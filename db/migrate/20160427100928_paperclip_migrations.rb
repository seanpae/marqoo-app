class PaperclipMigrations < ActiveRecord::Migration
  def up
    add_attachment :users, :avatar
    add_attachment :categories, :thumbnail
  end

  def down
    remove_attachment :users, :avatar
    remove_attachment :categories, :thumbnail
  end
end
