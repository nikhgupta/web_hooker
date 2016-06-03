class SubmissionSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :host, :ip
  attributes :request_method, :content_type, :content_length
  attributes :failed_replies_count, :successful_replies_count, :pending_replies_count
  attributes :created_at, :timestamp, :timestamp_in_words
  attributes :type, :payload, :body, :headers, :headers_list

  has_many :replies

  belongs_to :portal

  def replies
    object.replies_including_awaited
  end

  def timestamp
    object.created_at.iso8601
  end

  def timestamp_in_words
    scope.time_ago_in_words(object.created_at) + " ago"
  end

  def headers_list
    t, h = [], object.headers
    t << "#{h.delete("Version")} #{h.delete("Host")}"
    h.each{ |key, val| t << "#{key}: #{val}" }
    t
  end

  def type
    case object.status
    when :failure then :danger
    when :successful then :success
    when :pending, :partially_successful then :warning
    else :info
    end
  end
end
