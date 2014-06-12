FactoryGirl.define do
  factory :campaign do
    sequence(:name) { |k| "Campaign-#{k}" }
    state { |k| k.association(:state) }
    district { |k| k.association(:district) }
    school { |k| k.association(:school) }
    teacher { |k| k.association(:teacher) }
    active true
  end
end
