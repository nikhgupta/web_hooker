class Submission < ActiveRecord::Base
  belongs_to :portal, counter_cache: true
  has_many :replies, dependent: :destroy
  has_many :destinations, through: :portal

  # validates :host, presence: true
  validates :uuid, presence: true, uniqueness: true
  validates :request_method, presence: true
  validates :portal_id, presence: true

  serialize :headers, JSON
  serialize :payload, JSON

  def pending?
    portal.destinations_count > failed_replies_count + successful_replies_count
  end

  def successful?
    portal.destinations_count == successful_replies_count
  end

  def failed?
    portal.destinations_count == failed_replies_count
  end
  alias :failure? :failed?

  def status
    matched = %w(pending successful failed).detect{ |key| send("#{key}?") }
    matched ? matched.to_sym : :partially_successful
  end

  # def partially_successful?
  #   status == :partially_successful
  # end

  def pending_replies_count
    portal.destinations_count - failed_replies_count - successful_replies_count
  end

  def replies_including_awaited
    destinations.map{|destin| Reply.for(self, destin)}
  end
end
