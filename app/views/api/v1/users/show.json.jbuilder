json.user do
	json.id @user.id
	json.name @user.name
	json.email @user.email
	json.description @user.description

	json.follower_count @user.followers_count
	json.following_count @user.follow_count
	json.videos_count @user.videos.count  

	json.video_count @user.videos.count 

	json.avatar do
		json.large @user.avatar.url(:large)
		json.small @user.avatar.url(:thumb)
	end 

	if user_signed_in?
		json.follows_user current_user.follows_user?(@user)? true : false
	else 
		json.follows_user false
	end

	json.pagination do
	  json.current_page @videos.current_page
      json.total_pages @videos.total_pages
      json.next_page @videos.next_page
      json.previous_page @videos.previous_page
	end

	json.videos do  
		json.array! @videos do |video|
			json.title video.title
			json.description video.description
			json.created_at video.created_at
			json.comment_count video.comments.count
			json.id video.id

			if video.video.file? 
				json.url video.video.url(:medium)
				json.thumbnail video.video.url(:thumb)
			else 
				json.url video.video_source
				json.thumbnail video.thumbnail_url
			end

			if user_signed_in?
				json.is_like current_user.likes_video?(video)? true : false
			else 
				json.is_like false
			end

			json.likes video.likes_count
			json.views video.view_count
			json.category video.category.name

			json.user do
				json.name video.user.name
				json.id video.user.id

				if user_signed_in? 
					json.current_user current_user.id
				end

				json.avatar do
					json.thumbnail video.user.avatar.url(:thumb)
					json.large video.user.avatar.url(:large)
				end
			end

			json.comments do
				json.array! video.comments do |comment|
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
end
