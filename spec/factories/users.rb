FactoryGirl.define do
  factory :user do
    sequence(:email) { |k| "user-#{k}@example.com"}
    password "foobar123"
    password_confirmation "foobar123"
  end
end
