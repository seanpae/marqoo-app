json.user do 
	json.array! @user.each do |follower|
		json.id follower.id
		json.name follower.name
		json.email follower.email

		json.follower_count follower.followers_count
		json.following_count follower.follow_count

		json.video_count follower.videos.count

		json.avatar do
			json.large follower.avatar.url(:large)
			json.small follower.avatar.url(:thumb)
		end
	end
end