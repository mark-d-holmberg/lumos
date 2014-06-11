require 'rails_helper'

RSpec.describe State, type: :model do
  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:state)).to be_valid
    end

    it "should require a name" do
      expect(build(:state, name: nil)).to_not be_valid
    end

    it "should require a unique name" do
      create(:state, name: 'utah')
      expect(build(:state, name: 'utah')).to_not be_valid
    end

    it "should require a unique name regardless of case" do
      create(:state, name: 'utah')
      expect(build(:state, name: 'UTAH')).to_not be_valid
    end

    it "should require the abbreviation" do
      expect(build(:state, abbr: nil)).to_not be_valid
    end

    it "should require a unique abbreviation" do
      create(:state, abbr: 'ut')
      expect(build(:state, abbr: 'ut')).to_not be_valid
    end

    it "should require a unique abbreviation regardless of case" do
      create(:state, abbr: 'ut')
      expect(build(:state, abbr: 'UT')).to_not be_valid
    end
  end

  describe "concerning associations" do
    it "should have many districts" do
      state = create(:state, name: "Utah", abbr: 'UT')
      district_1 = create(:district, state: state)
      district_2 = create(:district, state: state)
      expect(state.districts).to match_array([district_1, district_2])
    end
  end

  describe "concerning ActiveRecord callbacks" do
    it "should destroy dependent districts" do
      state = create(:state, name: "Utah", abbr: 'UT')
      district = create(:district, state: state)
      state.destroy
      expect {
        district.reload
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
