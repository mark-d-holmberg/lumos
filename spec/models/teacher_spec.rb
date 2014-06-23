require 'rails_helper'

RSpec.describe Teacher, type: :model do
  describe "concering validations" do
    it "should have a valid factory" do
      expect(build(:teacher)).to be_valid
    end

    it "should require the first_name" do
      expect(build(:teacher, first_name: nil)).to_not be_valid
    end

    it "should require the last_name" do
      expect(build(:teacher, last_name: nil)).to_not be_valid
    end

    it "should require the school" do
      expect(build(:teacher, school: nil)).to_not be_valid
    end

    it "should require an email" do
      expect(build(:teacher, email: nil)).to_not be_valid
    end

    it "should require a unique email regardless of case" do
      expect(create(:teacher, email: "mark@example.com")).to be_valid
      expect(build(:teacher, email: "mark@example.com")).to_not be_valid
      expect(build(:teacher, email: "MARK@EXAMPLE.COM")).to_not be_valid
    end

    it "should not let the same email have a different name" do
      expect(create(:teacher, first_name: "Mark", last_name: "Holmberg", email: "mark@example.com")).to be_valid
      expect(build(:teacher, first_name: "Dixie", last_name: "Holmberg", email: "mark@example.com")).to_not be_valid
    end

    it "should accept accept properly formatted email addresses" do
      %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp].each do |valid_email_address|
        expect(build(:teacher, email: valid_email_address)).to be_valid
      end
    end

    it "should reject invalid email addresses" do
      expect(build(:teacher, email: "foo")).to_not be_valid
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.].each do |address|
        expect(build(:teacher, email: address)).to_not be_valid
      end
    end

    it "should make sure to avoid duplicate teachers for the same school" do
      distrct_1 = create(:district, name: "Washington County")
      distrct_2 = create(:district, name: "Iron County")
      school_1 = create(:school, name: 'Snow Canyon', district: distrct_1)
      school_2 = create(:school, name: 'Desert Hills', district: distrct_2)

      # The first record should be valid
      expect(create(:teacher, first_name: 'Mark', last_name: 'Holmberg', school: school_1)).to be_valid

      # It should allow people with the same last name but different first names
      expect(create(:teacher, first_name: 'Dixie', last_name: 'Holmberg', school: school_1)).to be_valid

      # It should prevent the duplicate for the same school
      expect(build(:teacher, first_name: 'Mark', last_name: 'Holmberg', school: school_1)).to_not be_valid

      # But allow them for different schools
      expect(build(:teacher, first_name: 'Mark', last_name: 'Holmberg', school: school_2)).to be_valid
    end
  end

  describe "concerning associations" do
    it "should belong to a school" do
      school = create(:school, name: 'Snow Canyon')
      expect(create(:teacher, school: school).school).to eql(school)
    end

    it "should have many campaigns" do
      teacher = create(:teacher, first_name: 'Mark', last_name: 'Holmberg')
      campaign_1 = create(:campaign, campaignable: teacher, school: teacher.school, district: teacher.school.district, state: teacher.school.district.state)
      campaign_2 = create(:campaign, campaignable: teacher, school: teacher.school, district: teacher.school.district, state: teacher.school.district.state)
      expect(teacher.campaigns).to match_array([campaign_1, campaign_2])
    end

    it "should have many contributions through their teacher based campaigns" do
      teacher = create(:teacher, first_name: 'Mark', last_name: 'Holmberg')
      campaign = create(:campaign, campaignable: teacher, school: teacher.school, district: teacher.school.district, state: teacher.school.district.state)
      contribution_1 = create(:contribution, campaign: campaign, amount_cents: 1337)
      contribution_2 = create(:contribution, campaign: campaign, amount_cents: 5443)
      expect(teacher.contributions).to match_array([contribution_1, contribution_2])
    end
  end

  describe "concerning public instance methods" do
    it "should have a full_name method" do
      expect(build(:teacher, first_name: 'Mark', last_name: 'Holmberg').full_name).to eql("Mark Holmberg")
    end
  end

  describe "concerning ActiveRecord callbacks" do
    it "should not be destroyable if it has campaigns" do
      teacher = create(:teacher, first_name: 'Mark', last_name: 'Holmberg')
      campaign = create(:campaign, campaignable: teacher, school: teacher.school, district: teacher.school.district, state: teacher.school.district.state)
      expect {
        teacher.destroy
      }.to_not change(Teacher, :count)
    end
  end

  describe "concerning constants and prefixes" do
    it "should know how to describe a rose by any other name" do
      expect(Teacher::SUPERIORITY_PREFIXES).to match_array(["Ms", "Miss", "Mrs", "Mr", "Doctor", "Professor"])
    end

    it "should know how to describe the prestigious_name to all lesser mortals" do
      expect(build(:teacher, first_name: 'Mark', last_name: 'Holmberg', prefix: 'Dark Lord').prestigious_name).to eql("Dark Lord Mark Holmberg")
    end
  end
end
