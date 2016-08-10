class Like < ActiveRecord::Base
	belongs_to :user, touch: true
	belongs_to :video, :touch => true

	validates_uniqueness_of :video_id, scope: :user_id

	default_scope -> { order('likes.created_at DESC') }

	validates :user_id, presence: true
	validates :video_id, presence: true
end
