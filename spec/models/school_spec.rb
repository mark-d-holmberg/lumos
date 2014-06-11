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
end
