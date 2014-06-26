FactoryGirl.define do
  factory :campaign do
    sequence(:name) { |k| "Campaign-#{k}" }
    state { |k| k.association(:state) }
    district { |k| k.association(:district, state: state) }
    school { |k| k.association(:school, district: district) }
    campaignable { |k| k.association(:teacher, school: school) }
    school_wide false
    active true
    goal_amount 1
    goal_amount_dollars nil
    product { |k| k.association(:product) }
    physical_address { Faker::Address.street_address }
    physical_address_ext { Faker::Address.secondary_address}
    physical_city { Faker::Address.city }
    physical_state { Faker::Address.state }
    physical_postal_code { Faker::Address.zip_code }
  end

  # School based campaign
  factory :school_based_campaign, parent: :campaign, class: 'Campaign' do
    campaignable { |k| k.school }
    school_wide true
    active true
  end
end
