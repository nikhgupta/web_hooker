class Submission < ActiveRecord::Base
  belongs_to :portal, counter_cache: true
  has_many :replies, dependent: :destroy
  has_many :destinations, through: :portal

  # validates :host, presence: true
  validates :uuid, presence: true, uniqueness: true
  validates :request_method, presence: true

  serialize :headers, JSON

  def pending?
    portal.destinations_count > failed_replies_count + successful_replies_count
  end

  def successful?
    portal.destinations_count == successful_replies_count
  end

  def failure?
    portal.destinations_count == failed_replies_count
  end

  def status
    matched = %w(pending successful failure).detect{ |key| send("#{key}?") }
    matched ? matched.to_sym : :partially_successful
  end

  def partially_successful?
    status == :partially_successful
  end
end
