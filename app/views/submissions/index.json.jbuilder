json.array!(@submissions) do |submission|
  json.extract! submission, :id, :portal_id, :host, :ip, :uuid, :request_method, :content_type, :content_length, :headers, :body, :successful_replies_count, :failed_replies_count
  json.url submission_url(submission, format: :json)
end
