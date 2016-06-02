class ReplySerializer < ActiveModel::Serializer
  belongs_to :submission
  belongs_to :destination

  attributes :id, :content_type, :http_status_code
  attributes :response_time, :content_length
  attributes :created_at

  attributes :body
  attributes :headers

  def headers
    object.headers.map{|k,v| "#{k.titleize.gsub(/\s+/, '-')}: #{v}"}
  end
end

