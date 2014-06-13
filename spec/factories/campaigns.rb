FactoryGirl.define do
  factory :campaign do
    sequence(:name) { |k| "Campaign-#{k}" }
    state { |k| k.association(:state) }
    district { |k| k.association(:district, state: state) }
    school { |k| k.association(:school, district: district) }
    teacher { |k| k.association(:teacher, school: school) }
    active true
  end
end
