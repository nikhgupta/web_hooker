class DestinationSerializer < ActiveModel::Serializer
  attributes :id, :url, :created_at

  belongs_to :portal
  has_many :replies
end

