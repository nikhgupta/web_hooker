class Portal < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  has_many :submissions,  dependent: :destroy
  has_many :destinations, dependent: :destroy

  validates :title, presence: true
  validates :slug,  presence: true, uniqueness: true
  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug = Digest::SHA512.hexdigest(SecureRandom.uuid)[25..72]
    generate_slug if self.class.find_by(slug: self.slug).present?
  end
end
