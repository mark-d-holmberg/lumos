require 'rails_helper'

RSpec.describe School, type: :model do
  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:school)).to be_valid
    end

    it "should require a name" do
      expect(build(:school, name: nil)).to_not be_valid
    end

    it "should require a district" do
      expect(build(:school, district: nil)).to_not be_valid
    end

    it "should require a unique name scoped to the district" do
      district_1 = create(:district, name: 'Washington County')
      district_2 = create(:district, name: 'Mojave County')
      create(:school, name: 'Snow Canyon', district: district_1)
      expect(build(:school, name: 'Snow Canyon', district: district_1)).to_not be_valid
      expect(build(:school, name: 'Snow Canyon', district: district_2)).to be_valid
    end
  end

  describe "concerning relations" do
    it "should belong to a district" do
      district = create(:district, name: 'Washington County')
      school = create(:school, name: 'Snow Canyon', district: district)
      expect(school.district).to eq(district)
    end

    it "should have many teachers" do
      school = create(:school, name: 'Snow Canyon')
      teacher_1 = create(:teacher, school: school)
      teacher_2 = create(:teacher, school: school)
      expect(school.teachers).to match_array([teacher_1, teacher_2])
    end

    it "should have many teacher based campaigns" do
      school = create(:school, name: 'Snow Canyon')
      campaign_1 = create(:campaign, school: school, district: school.district, state: school.district.state, school_wide: false)
      campaign_2 = create(:campaign, school: school, district: school.district, state: school.district.state, school_wide: false)
      expect(school.campaigns).to match_array([campaign_1, campaign_2])
    end

    it "should have many school_wide_campaigns as long as only one is active" do
      school = create(:school, name: 'Snow Canyon')
      campaign_1 = create(:campaign, campaignable: school, campaignable_type: 'School', school: school, district: school.district, state: school.district.state, school_wide: true, active: true)
      campaign_2 = create(:campaign, campaignable: school, campaignable_type: 'School', school: school, district: school.district, state: school.district.state, school_wide: true, active: false)
      expect(school.school_wide_campaigns).to match_array([campaign_1, campaign_2])
    end
  end

  describe "concernign ActiveRecord callbacks" do
    it "should not be destroyable if it has teachers" do
      school = create(:school, name: "Snow Canyon")
      teacher = create(:teacher, school: school)
      expect {
        school.destroy
      }.to_not change(School, :count)
    end

    it "should not be destroyable if it has teacher based campaigns" do
      school = create(:school, name: "Snow Canyon")
      campaign = create(:campaign, school: school, district: school.district, state: school.district.state)
      expect {
        school.destroy
      }.to_not change(School, :count)
    end

    it "should not be destroyable if it has school_wide campaigns" do
      school = create(:school, name: "Snow Canyon")
      campaign = create(:campaign, school: school, district: school.district, state: school.district.state, campaignable: school, school_wide: true)
      expect {
        school.destroy
      }.to_not change(School, :count)
    end
  end

end
