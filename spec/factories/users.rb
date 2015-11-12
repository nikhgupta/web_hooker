FactoryGirl.define do
  factory :user do
    sequence(:email){ |n| "user#{n}@example.com" }
    password "password"
    password_confirmation { password }
    admin false

    factory :admin do
      admin true
      confirmed true
    end

    factory :confirmed_user do
      confirmed true
    end

    transient do
      confirmed false
    end

    initialize_with do
      User.find_or_initialize_by(email: email)
    end

    after(:build) do |user, evaluator|
      user.confirm if evaluator.confirmed
    end
  end
end
