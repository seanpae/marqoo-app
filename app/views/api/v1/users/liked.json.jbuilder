json.pagination do
	json.current_page @liked.current_page
    json.total_pages @liked.total_pages
    json.next_page @liked.next_page
    json.previous_page @liked.previous_page
end
json.videos do 
	json.array! @liked do |like|
		json.title like.video.title
		json.description like.video.description
		json.created_at like.video.created_at
		json.comment_count like.video.comments.count
		json.id like.video.id
		json.category like.video.category.name
		json.class "likes"

		if like.video.video.file? 
			json.url like.video.video.url(:medium)
			json.thumbnail like.video.video.url(:thumb)
			json.views like.video.view_count
		else 
			json.url like.video.video_source
			json.thumbnail like.video.thumbnail_url
			json.views like.video.view_count
		end

		if user_signed_in?
			json.is_like current_user.likes_video?(like.video)? true : false
		else 
			json.is_like false
		end

		json.user do
			json.name like.video.user.name
			json.id like.video.user.id

			if user_signed_in? 
				json.current_user current_user.id
			end

			json.avatar do
				json.thumbnail like.video.user.avatar.url(:thumb)
				json.large like.video.user.avatar.url(:large)
			end
		end

		json.comments do
			json.array! like.video.comments do |comment|
			  if !comment.user.blank?
				json.id comment.id
				json.comment comment.content

				json.user do 
					json.id comment.user.id
					json.name comment.user.name
					json.avatar do 
						json.thumbnail comment.user.avatar.url(:thumb)
						json.large comment.user.avatar.url(:large)
					end
				end
			  end
			end	
		end
	end
end