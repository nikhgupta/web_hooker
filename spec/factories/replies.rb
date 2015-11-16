FactoryGirl.define do
  factory :reply do
    destination
    submission
    account { submission.account }

    content_type nil
    response_time  0
    content_length 0
    http_status_code 200

    body ""
    headers Hash.new
  end
end
