FactoryGirl.define do
  factory :destination do
    portal
    account { portal.account }
    url "http://someurl.com"
  end
end
