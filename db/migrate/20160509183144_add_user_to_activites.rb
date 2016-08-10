class AddUserToActivites < ActiveRecord::Migration
  def change
  	add_column :activities, :trackable_user, :integer
  end
end
