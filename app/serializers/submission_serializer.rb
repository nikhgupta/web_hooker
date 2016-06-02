class SubmissionSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :type, :headers

  has_one  :portal
  has_many :replies

  def type
    case object.status
    when :failure then :danger
    when :successful then :success
    when :pending, :partially_successful then :warning
    else :info
    end
  end

  def timestamp
    object.created_at.iso8601
  end

  def timestamp_in_words
    scope.time_ago_in_words(object.created_at) + " ago"
  end

  def headers
    t, h = [], object.headers
    t << "#{h.delete("Version")} #{h.delete("Host")}"
    h.each{ |key, val| t << "#{key}: #{val}" }
    t
  end
end
