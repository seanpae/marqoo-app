class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.references :user, index: true
      t.references :category, index:true 
      t.string :feed_name
      t.string :link

      t.timestamps null: false
    end
  end
end
