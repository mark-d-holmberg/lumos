FactoryGirl.define do
  factory :state do
    sequence(:name) { |k| "#{Faker::Address.state}-#{k}" }
    sequence(:abbr) { |k| "#{Faker::Address.state_abbr}-#{k}" }
  end
end
