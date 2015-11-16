class Portal < ActiveRecord::Base
  acts_as_tenant :account

  belongs_to :account, counter_cache: true
  validates :account_id, presence: true

  has_many :submissions,  dependent: :destroy
  has_many :destinations, dependent: :destroy

  validates :title, presence: true
  validates :slug,  presence: true, uniqueness: true
  before_validation :generate_slug, on: :create

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = Digest::SHA512.hexdigest(SecureRandom.uuid)[25..72]
    generate_slug if self.class.find_by(slug: self.slug).present?
  end
end
