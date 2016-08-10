json.title @video.title
json.description @video.description
json.created_at @video.created_at
json.comment_count @video.comments.count
json.id @video.id 

if @video.video.file?  
	json.url @video.video.url(:medium)
	json.thumbnail @video.video.url(:thumb) 
else 
	json.url @video.video_source
	json.thumbnail @video.thumbnail_url
end

if user_signed_in?
	json.is_like current_user.likes_video?(@video)? true : false
else 
	json.is_like false
end 

json.likes @video.likes.count
json.views @video.view_count
json.category @video.category.name

json.user do
	json.name @video.user.name
	json.id @video.user.id
	json.description @video.user.description

	if user_signed_in? 
		json.current_user current_user.id
	end

	json.avatar do
		json.thumbnail @video.user.avatar.url(:thumb)
		json.large @video.user.avatar.url(:large)
	end
end

json.comments do
	json.array! @video.comments do |comment|
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