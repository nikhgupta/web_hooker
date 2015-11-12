FactoryGirl.define do
  factory :reply do
    destination
    submission
    http_status_code 200
    content_length nil
    content_type nil
    headers {}
    body ""
    processed_at nil
  end
end
