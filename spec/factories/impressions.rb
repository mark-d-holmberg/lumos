FactoryGirl.define do
  factory :impression do
    sequence(:email) { |k| "impression-#{k}@example.com" }
    campaign { |k| k.association(:campaign) }
    referral_kind "search"
    token nil
  end
end
