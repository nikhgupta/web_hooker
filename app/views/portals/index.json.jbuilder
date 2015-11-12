json.array!(@portals) do |portal|
  json.extract! portal, :id, :title, :slug, :destinations_count
  json.url portal_url(portal, format: :json)
end
