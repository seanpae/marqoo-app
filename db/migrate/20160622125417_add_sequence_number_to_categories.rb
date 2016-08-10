class AddSequenceNumberToCategories < ActiveRecord::Migration
  def change
  	add_column :categories, :sequence_number, :integer
  end
end
