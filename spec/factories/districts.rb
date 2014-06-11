FactoryGirl.define do
  factory :district do
    sequence(:name) { |k| "District-#{k}" }
    state { |k| k.association(:state) }
  end
end
