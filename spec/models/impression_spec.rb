require 'rails_helper'

RSpec.describe Impression, type: :model do
  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:impression)).to be_valid
    end

    it "should require a valid email" do
      expect(build(:impression, email: nil)).to_not be_valid
    end

    it "should accept accept properly formatted email addresses" do
      %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp].each do |valid_email_address|
        expect(build(:impression, email: valid_email_address)).to be_valid
      end
    end

    it "should reject invalid email addresses" do
      expect(build(:impression, email: "foo")).to_not be_valid
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.].each do |address|
        expect(build(:impression, email: address)).to_not be_valid
      end
    end

    it "should require a campaign" do
      expect(build(:impression, campaign: nil)).to_not be_valid
    end
  end
end
