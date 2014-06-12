FactoryGirl.define do
  factory :contributor do
    sequence(:name) { |k| "Contributor-#{k}" }
    sequence(:email) { |k| "user-#{k}@example.com" }
  end
end
