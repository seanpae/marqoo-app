json.notifications do
  json.array! @notifications do |notification|
    json.id notification.id
    json.created_at notification.created_at
 
    json.from do
    	json.user_id notification.user_id
    	json.name User.find(notification.user_id).name
    	json.avatar User.find(notification.user_id).avatar.url(:thumb)
    end

    json.object do 
    	json.type notification.trackable_type
    	json.object_id notification.trackable_id
    	json.action notification.action

    	if notification.trackable_type == "Comment"
    		json.comment Comment.find(notification.trackable_id).content
    	    json.video_id Comment.find(notification.trackable_id).video_id

            json.video_title Comment.find(notification.trackable_id).video.title 
 
            if Comment.find(notification.trackable_id).video.video.file?  
                json.url Comment.find(notification.trackable_id).video.video.url(:medium)
                json.thumbnail Comment.find(notification.trackable_id).video.video.url(:thumb) 
            else 
                json.url Comment.find(notification.trackable_id).video.video_source
                json.thumbnail Comment.find(notification.trackable_id).video.thumbnail_url
            end

            json.user_avatar Comment.find(notification.trackable_id).video.user.avatar.url(:thumb)
            json.user_name Comment.find(notification.trackable_id).video.user.name
            json.user_description Comment.find(notification.trackable_id).video.user.description
            json.user_id Comment.find(notification.trackable_id).video.user.id
            json.description Comment.find(notification.trackable_id).video.description 
            json.comment_count Comment.find(notification.trackable_id).video.comments.count
            json.like_count Comment.find(notification.trackable_id).video.likes_count

            if user_signed_in?
                json.is_like current_user.likes_video?(Comment.find(notification.trackable_id).video)? true : false
            else 
                json.is_like false
            end 

            if user_signed_in? 
                json.current_user current_user.id
            end
        end

        if notification.trackable_type == "User"
            json.user_id notification.trackable_id
            json.name User.find(notification.trackable_id).name
            json.avatar User.find(notification.trackable_id).avatar.url(:thumb)
        end

    	if notification.trackable_type == "Like"
    		json.like_id notification.trackable_id
    		json.title Like.find(notification.trackable_id).video.title
            json.video_id Like.find(notification.trackable_id).video_id
    		json.user do
    			json.id Like.find(notification.trackable_id).video.user.id
    			json.name Like.find(notification.trackable_id).video.user.name
    			json.name Like.find(notification.trackable_id).video.user.avatar.url(:thumb)
    		end

            json.video_title Like.find(notification.trackable_id).video.title 

            if Like.find(notification.trackable_id).video.video.file?  
                json.url Like.find(notification.trackable_id).video.video.url(:medium)
                json.thumbnail Like.find(notification.trackable_id).video.video.url(:thumb) 
            else 
                json.url Like.find(notification.trackable_id).video.video_source
                json.thumbnail Like.find(notification.trackable_id).video.thumbnail_url
            end

            json.user_avatar Like.find(notification.trackable_id).video.user.avatar.url(:thumb)
            json.user_name Like.find(notification.trackable_id).video.user.name
            json.user_description Like.find(notification.trackable_id).video.user.description
            json.user_id Like.find(notification.trackable_id).video.user.id
            json.description Like.find(notification.trackable_id).video.description 
            json.comment_count Like.find(notification.trackable_id).video.comments.count
            json.like_count Like.find(notification.trackable_id).video.likes_count

            if user_signed_in?
                json.is_like current_user.likes_video?(Like.find(notification.trackable_id).video)? true : false
            else 
                json.is_like false
            end 

            if user_signed_in? 
                json.current_user current_user.id
            end
    	end
    end
  end
end