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
  end

  describe "concernign ActiveRecord callbacks" do
    it "destroys dependent teachers" do
      school = create(:school, name: 'Snow Canyon')
      teacher = create(:teacher, school: school)
      school.destroy
      expect {
        teacher.reload
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
