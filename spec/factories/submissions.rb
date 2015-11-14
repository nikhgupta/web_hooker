FactoryGirl.define do
  factory :submission do
    portal

    host "SomeHost.com"
    ip nil
    uuid { SecureRandom.uuid }
    request_method "get"

    content_type nil
    content_length 0
    failed_replies_count 0
    successful_replies_count 0

    body ""
    headers Hash.new

    transient do
      with_destinations 0
      with_failed_replies 0
      with_successful_replies 0
    end

    after(:create) do |submission, evaluator|
      total_replies = evaluator.with_failed_replies + evaluator.with_successful_replies
      if total_replies > evaluator.with_destinations
        raise ArgumentError, "Replies cannot be more than Destinations"
      end

      create_list(:destination, evaluator.with_destinations.to_i, portal: submission.portal)

      submission.destinations.shuffle.take(evaluator.with_successful_replies.to_i).each do |destin|
        create :reply, submission: submission, destination: destin, http_status_code: 200
      end

      submission.destinations.shuffle.take(evaluator.with_failed_replies.to_i).each do |destin|
        create :reply, submission: submission, destination: destin, http_status_code: 400
      end

      # submission.update_attributes(
      #   failed_replies_count: evaluator.with_failed_replies.to_i,
      #   successful_replies_count: evaluator.with_successful_replies.to_i
      # )
    end
  end
end
