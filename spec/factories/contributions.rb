FactoryGirl.define do
  factory :contribution do
    sequence(:pledge_id) { |k| k }
    pledged_at { Time.zone.now }
    contributor { |k| k.association(:contributor) }
    campaign { |k| k.association(:campaign) }
    amount 1
    amount_dollars nil
    sequence(:impression_token) { |k| "impression_token-#{k}" }
  end
end
