class ReplySerializer < ActiveModel::Serializer
  belongs_to :submission
  belongs_to :destination

  attributes :id, :content_type, :http_status_code, :http_status_message
  attributes :response_time, :content_length, :status, :status_style
  attributes :created_at

  attributes :body, :destination_url
  attributes :headers, :headers_list, :headers_with_body

  def headers_list
    object.headers.map{|k,v| "#{k.titleize.gsub(/\s+/, '-')}: #{v}"}
  end

  def destination_url
    object.destination.url
  end

  def content_length
    text = scope.number_to_human_size object.content_length
    text.gsub(" ", '').gsub("Bytes", "B").upcase
  end

  def status_style
    case object.status
    when :successful then :success
    when :failed then :danger
    when :pending then :default
    else :warning
    end
  end

  def headers_with_body
    return headers_list if object.body.blank?
    return [object.body] if headers_list.blank?
    list = headers_list << "" << "" << object.body
    list.all?(&:blank?) ? [] : list
  end
end

