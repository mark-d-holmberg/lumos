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
end
