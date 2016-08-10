json.array!(@comments) do |comment|
  json.extract! comment, :id, :video_id, :comment, :user_id
  json.url comment_url(comment, format: :json)
end
