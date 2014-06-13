FactoryGirl.define do
  factory :campaign do
    sequence(:name) { |k| "Campaign-#{k}" }
    state { |k| k.association(:state) }
    district { |k| k.association(:district, state: state) }
    school { |k| k.association(:school, district: district) }
    campaignable { |k| k.association(:teacher, school: school) }
    school_wide false
    active true
  end
end
