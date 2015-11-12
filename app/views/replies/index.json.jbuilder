json.array!(@replies) do |reply|
  json.extract! reply, :id, :destination_id, :submission_id, :http_status_code, :content_length, :content_type, :headers, :body, :processed_at
  json.url reply_url(reply, format: :json)
end
