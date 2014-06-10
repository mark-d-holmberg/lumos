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
end
