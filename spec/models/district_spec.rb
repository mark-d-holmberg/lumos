require 'rails_helper'

RSpec.describe District, type: :model do

  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:district)).to be_valid
    end

    it "should require a name" do
      expect(build(:district, name: nil)).to_not be_valid
    end

    it "should require a state" do
      expect(build(:district, state: nil)).to_not be_valid
    end

    it "should require a unique name scoped to state" do
      utah = create(:state, name: 'Utah', abbr: 'UT')
      nevada = create(:state, name: 'Nevada', abbr: 'NV')
      create(:district, name: 'Washington County', state: utah)
      expect(build(:district, name: 'Washington County', state: utah)).to_not be_valid
      expect(build(:district, name: 'Washington County', state: nevada)).to be_valid
    end
  end

  describe "concerning relations" do
    it "should belong to a state" do
      state = create(:state, name: 'Utah', abbr: 'UT')
      district = create(:district, state: state)
      expect(district.state).to eql(state)
    end

    it "should have many schools" do
      district = create(:district, name: 'Washington County')
      school_1 = create(:school, name: 'Snow Canyon', district: district)
      school_2 = create(:school, name: 'Desert Hills', district: district)
      expect(district.schools).to match_array([school_1, school_2])
    end
  end

  describe "concerning ActiveRecord callbacks" do
    it "should destroy dependent schools" do
      district = create(:district, name: 'Washington County')
      school = create(:school, name: 'Snow Canyon', district: district)
      district.destroy
      expect {
        school.reload
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
