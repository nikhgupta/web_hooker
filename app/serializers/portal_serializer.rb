class PortalSerializer < ActiveModel::Serializer
  has_many :submissions
  def type
    case object.status
    when :failure then :danger
    when :successful then :success
    when :pending, :partially_successful then :warning
    else :info
    end
  end
end
