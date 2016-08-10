class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :video, touch: true

	validates :user_id, presence: true
	validates :content, presence: true
	
end
