i=0
json.categories do 
	json.array! @categories do |category|
		json.id category.id
		json.name category.name
		if !@token.blank?
			json.video_count category.videos.where.not(user_id: @b_user, reported: true, :active => false).count
		else
			json.video_count category.videos.where(:active => true).count
		end
		json.image_url @my_array[i]
		i += 1	
	end
end