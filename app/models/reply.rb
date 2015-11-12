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

  def http_status_message
    Rack::Utils::HTTP_STATUS_CODES[http_status_code]
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
