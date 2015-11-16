FactoryGirl.define do
  factory :account do
    sequence(:subdomain){|n| "subdomain#{n}"}

    initialize_with do
      Account.find_or_initialize_by(subdomain: subdomain)
    end
  end
end
