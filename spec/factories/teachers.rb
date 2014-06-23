FactoryGirl.define do
  factory :teacher do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    school { |k| k.association(:school) }
    sequence(:email) { |k| "teacher-#{k}@example.com" }
  end
end
