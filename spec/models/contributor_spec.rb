require 'rails_helper'

RSpec.describe Contributor, type: :model do
  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:contributor)).to be_valid
    end

    it "should require a name" do
      expect(build(:contributor, name: nil)).to_not be_valid
    end

    it "should require an email" do
      expect(build(:contributor, email: nil)).to_not be_valid
    end

    it "should require a unique email regardless of case" do
      expect(create(:contributor, email: "mark@example.com")).to be_valid
      expect(build(:contributor, email: "mark@example.com")).to_not be_valid
      expect(build(:contributor, email: "MARK@EXAMPLE.COM")).to_not be_valid
    end

    it "should not let the same email have a different name" do
      expect(create(:contributor, name: "Mark Holmberg", email: "mark@example.com")).to be_valid
      expect(build(:contributor, name: "Dixie Holmberg", email: "mark@example.com")).to_not be_valid
    end

    it "should accept accept properly formatted email addresses" do
      %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp].each do |valid_email_address|
        expect(build(:contributor, email: valid_email_address)).to be_valid
      end
    end

    it "should reject invalid email addresses" do
      expect(build(:contributor, email: "foo")).to_not be_valid
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.].each do |address|
        expect(build(:contributor, email: address)).to_not be_valid
      end
    end
  end
end
