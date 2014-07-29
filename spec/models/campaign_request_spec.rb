require 'rails_helper'

RSpec.describe CampaignRequest, type: :model do
  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:campaign_request)).to be_valid
    end

    it "should require a state" do
      expect(build(:campaign_request, state_id: nil)).to_not be_valid
    end
  end

  describe "concerning converting a campaign request" do
    before(:each) do
      @utah = create(:state, name: 'Utah', abbr: 'UT')
      @nevada = create(:state, name: 'Nevada', abbr: 'NV')
      @district_1 = create(:district, state: @utah, name: 'Washington County')
      @district_2 = create(:district, state: @nevada, name: 'Mojave County')
      @school_1 = create(:school, name: 'Snow Canyon', district: @district_1)
      @school_2 = create(:school, name: 'Desert Hills', district: @district_2)
      @teacher_1 = create(:teacher, first_name: 'Mark', last_name: 'Holmberg', prefix: 'Dark Overlord', school: @school_1)
      @teacher_2 = create(:teacher, first_name: 'Dave', last_name: 'McBride', prefix: 'Peasant', school: @school_2)
    end

    it "should be able to do it with everything manually set" do
      campaign_request = create(:campaign_request,
        state: @utah,
        district_name: 'Washington County',
        school_name: 'Jewballs High School',
        teacher_name: 'Jewballs McCoy',
        campaign_name: 'Jew Balls Campaign for Stuff',
        school_wide: true,
        email: "whatevadads@example.com",
      )
      partial_params = {"state_id"=> @utah.id, "school_wide"=>"true", "email"=>"whatevadads@example.com", "associations"=>{"district_id"=> @district_1.id, "school_id"=>""}, "school_name"=>"Jewballs High School", "teacher_name"=>"Jewballs McCoy", "campaign_name"=>"Jew Balls Campaign for Stuff"}
      campaign_request.convert(partial_params)
      expect(State.find(@utah.id)).to_not be_nil
      expect(@utah.districts.find(@district_1.id)).to_not be_nil
      expect(@district_1.schools.find_by(name: 'Jewballs High School')).to_not be_nil
      expect(Teacher.find_by(last_name: 'McCoy', first_name: 'Jewballs')).to_not be_nil
    end

    it "should be able to work with some manual set and some overridden" do
      campaign_request = create(:campaign_request,
        state: @utah,
        district_name: 'Washington County',
        school_name: 'Jewballs High School',
        teacher_name: 'Jewballs McCoy',
        campaign_name: 'Jew Balls Campaign for Stuff',
        school_wide: false,
        email: "whatevadads@example.com",
      )
      overridden_params = {"state_id"=> @nevada.id, "school_wide"=>"false", "email"=>"whatevadads@example.com", "associations"=>{"district_id"=> @district_2.id, "school_id"=>""}, "school_name"=>"Mojave Desert Hills", "teacher_name"=>"Herp Derp", "campaign_name"=>"Jew Balls Campaign for Stuff"}
      campaign_request.convert(overridden_params)
      expect(State.find(@nevada.id)).to_not be_nil
      expect(@nevada.districts.find(@district_2.id)).to_not be_nil
      expect(@district_2.schools.find_by(name: 'Mojave Desert Hills')).to_not be_nil
      expect(Teacher.find_by(last_name: 'Derp', first_name: 'Herp')).to_not be_nil
    end
  end
end
