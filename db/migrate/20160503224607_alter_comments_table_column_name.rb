class AlterCommentsTableColumnName < ActiveRecord::Migration
  def change
  	rename_column :comments, :comment, :content
  end
end
