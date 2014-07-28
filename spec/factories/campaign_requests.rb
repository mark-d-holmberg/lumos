FactoryGirl.define do
  factory :campaign_request do
    state { |k| k.association(:state) }
    district_name "MyString"
    school_name "MyString"
    teacher_name "MyString"
    campaign_name "MyString"
    school_wide false
    email "MyString"
    slug nil
  end
end
