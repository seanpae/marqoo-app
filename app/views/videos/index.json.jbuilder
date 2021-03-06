json.array!(@videos) do |video|
  json.extract! video, :id, :title, :description, :user_id, :source
  json.url video_url(video, format: :json)
end
