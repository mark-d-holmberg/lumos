require 'rails_helper'

RSpec.describe Campaign, type: :model do

  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:campaign)).to be_valid
    end

    it "should require the name" do
      expect(build(:campaign, name: nil)).to_not be_valid
    end

    it "should require a unique name regardless of case" do
      expect(create(:campaign, name: 'campaign')).to be_valid
      expect(build(:campaign, name: 'campaign')).to_not be_valid
      expect(build(:campaign, name: 'CAMPAIGN')).to_not be_valid
    end

    it "should require the state" do
      expect(build(:campaign, state: nil)).to_not be_valid
    end

    it "should require the district" do
      expect(build(:campaign, district: nil)).to_not be_valid
    end

    it "should require the school" do
      expect(build(:campaign, school: nil)).to_not be_valid
    end

    it "should require the teacher" do
      expect(build(:campaign, teacher: nil)).to_not be_valid
    end
  end

  describe "concerning relations" do
    it "should belong to a state" do
      state = create(:state, name: 'Utah', abbr: 'UT')
      campaign = create(:campaign, state: state)
      expect(campaign.state).to eql(state)
    end

    it "should belong to a district" do
      district = create(:district, name: 'Washington County')
      campaign = create(:campaign, district: district)
      expect(campaign.district).to eql(district)
    end

    it "should belong to a school" do
      school = create(:school, name: 'Snow Canyon')
      campaign = create(:campaign, school: school)
      expect(campaign.school).to eql(school)
    end

    it "should belong to a teacher" do
      teacher = create(:teacher, first_name: 'Mark', last_name: 'Holmberg')
      campaign = create(:campaign, teacher: teacher)
      expect(campaign.teacher).to eql(teacher)
    end
  end

  describe "concerning ActiveRecord callbacks" do
    it "should not be destroyable if it is active?" do
      campaign = create(:campaign, name: 'Campaign', active: true)
      expect {
        campaign.destroy
      }.to_not change(Campaign, :count)
    end

    it "should not be destroyable if it has contributions"
  end

end
