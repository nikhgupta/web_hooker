FactoryGirl.define do
  factory :submission do
    portal
    host "SomeHost.com"
    ip nil
    uuid { SecureRandom.uuid }
    request_method "get"
    content_type nil
    content_length nil
    headers {}
    body ""
    failed_replies_count 0
    successful_replies_count 0
  end
end
