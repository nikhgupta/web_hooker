class Destination < ActiveRecord::Base
  belongs_to :portal, counter_cache: true
  has_many :replies, dependent: :nullify
  has_many :submissions, through: :replies

  validates :url, presence: true
  validates :portal_id, presence: true
end
