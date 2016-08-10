json.comments do
	json.array! @comments do |comment|
	  if !comment.user.blank?
		json.id comment.id
		json.comment comment.content
		json.created_at comment.created_at
		
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