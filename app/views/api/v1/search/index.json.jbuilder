json.array! @results do |result|
	json.pagination do
      json.current_page @results.current_page
      json.total_pages @results.total_pages
      json.next_page @results.next_page
      json.previous_page @results.previous_page
    end
	if result.class == Video
		json.video do 
			json.user do
				json.name result.user.name
				json.id result.user.id
			end

			json.title result.title
			json.description result.description
			json.created_at result.created_at
			json.comment_count result.comments.count
			json.id result.id 

			if result.video.file?  
				json.url result.video.url(:medium)
				json.thumbnail result.video.url(:thumb)
			else 
				json.url result.video_source
				json.thumbnail result.thumbnail_url
			end

			if user_signed_in?
				json.is_like current_user.likes_video?(result)? true : false
			else 
				json.is_like false
			end 

			json.likes result.likes_count
			json.views result.view_count
			json.category result.category.name

			json.user do
				json.name result.user.name
				json.id result.user.id
				json.description result.user.description

				if user_signed_in? 
					json.current_user current_user.id
				end

				json.avatar do
					json.thumbnail result.user.avatar.url(:thumb)
					json.large result.user.avatar.url(:large)
				end
			end

			json.comments do
				json.array! result.comments do |comment|
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