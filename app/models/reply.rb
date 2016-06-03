class Reply < ActiveRecord::Base
  belongs_to :destination
  belongs_to :submission

  scope :failed, -> { where('http_status_code >= ?', 400) }
  scope :successful, -> { where('http_status_code < ?', 400) }

  after_create   :increment_counters_on_submission
  before_destroy :decrement_counters_on_submission

  serialize :headers, JSON

  def successful?
    http_status_code < 400
  end

  def failed?
    http_status_code && http_status_code.to_i >= 400
  end
  alias :failure? :failed?

  def pending?
    new_record? || http_status_code.blank?
  end

  def status
    matched = %w(pending successful failed).detect{ |key| send("#{key}?") }
    matched ? matched.to_sym : :unknown
  end

  def http_status_message
    Rack::Utils::HTTP_STATUS_CODES[http_status_code]
  end

  def self.for(submission, destination)
    find_or_initialize_by(
      submission_id:  submission.id,
      destination_id: destination.id
    )
  end

  def self.for(submission, destination)
    find_or_initialize_by(
      submission_id:  submission.id,
      destination_id: destination.id
    )
  end

  private

  def increment_counters_on_submission
    column = successful? ? :successful_replies_count : :failed_replies_count
    Submission.increment_counter(column, submission_id)
  end

  def decrement_counters_on_submission
    column = successful? ? :successful_replies_count : :failed_replies_count
    Submission.decrement_counter(column, submission_id)
  end
end
