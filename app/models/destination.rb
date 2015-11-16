class Destination < ActiveRecord::Base
  acts_as_tenant :account

  belongs_to :account, counter_cache: true
  validates :account_id, presence: true

  belongs_to :portal, counter_cache: true
  has_many :replies, dependent: :nullify
  has_many :submissions, through: :replies

  validates :url, presence: true
end
