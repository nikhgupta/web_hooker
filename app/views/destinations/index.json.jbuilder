json.array!(@destinations) do |destination|
  json.extract! destination, :id, :portal_id, :url
  json.url destination_url(destination, format: :json)
end
