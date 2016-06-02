class PortalSerializer < ActiveModel::Serializer
  attributes :id, :title, :slug
  attributes :submissions_count, :destinations_count
  attributes :created_at

  belongs_to :user
  has_many :submissions
end
