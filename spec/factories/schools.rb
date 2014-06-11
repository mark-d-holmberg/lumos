FactoryGirl.define do
  factory :school do
    sequence(:name) { |k| "School-#{k}" }
    district { |k| k.association(:district) }
  end
end
