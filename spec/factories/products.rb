FactoryGirl.define do
  factory :product do
    sequence(:name) { |k| "Product-#{k}" }
    description { Faker::Lorem.paragraph }
    price 1
    price_dollars nil
  end
end
