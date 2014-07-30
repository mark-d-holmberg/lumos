FactoryGirl.define do
  factory :campaign_request do
    state { |k| k.association(:state) }
    product { |k| k.association(:product, price: 500) }
    sequence(:district_name) { |k| "District-#{k}" }
    sequence(:school_name) { |k| "School-#{k}" }
    teacher_first_name { Faker::Name.first_name }
    teacher_last_name { Faker::Name.last_name }
    sequence(:campaign_name) { |k| "Campaign-#{k}" }
    school_wide false
    sequence(:email) { |k| "teacher-#{k}@example.com" }
    physical_address { Faker::Address.street_address }
    physical_address_ext { Faker::Address.secondary_address}
    physical_city { Faker::Address.city }
    physical_state { Faker::Address.state }
    physical_postal_code { Faker::Address.zip_code }
  end
end
