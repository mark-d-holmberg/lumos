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
      expect {
        build(:campaign, state: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should require the district" do
      expect {
        build(:campaign, district: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should require the school" do
      expect {
        build(:campaign, school: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should require the product" do
      expect(build(:campaign, product: nil)).to_not be_valid
    end

    it "should require the campaignable" do
      expect(build(:campaign, campaignable: nil)).to_not be_valid
    end

    it "should require the school_wide" do
      expect(build(:campaign, school_wide: nil)).to_not be_valid
    end

    it "should require an goal_amount" do
      expect(build(:campaign, goal_amount: nil)).to_not be_valid
    end

    it "should require a positive goal_amount" do
      expect(build(:campaign, goal_amount: 0)).to_not be_valid
      expect(build(:campaign, goal_amount: -1)).to_not be_valid
      expect(build(:campaign, goal_amount: 'abc')).to_not be_valid
    end

    it "should restrict teacher_based campaigns to a $900 limit" do
      expect(build(:campaign, school_wide: false, goal_amount: 900)).to be_valid
      expect(build(:campaign, school_wide: false, goal_amount: 1)).to be_valid
      expect(build(:campaign, school_wide: false, goal_amount: 901)).to_not be_valid
    end

    it "should not restrict the goal amount for school_wide campaigns" do
      expect(build(:school_based_campaign, goal_amount: 900)).to be_valid
      expect(build(:school_based_campaign, goal_amount: 1)).to be_valid
      expect(build(:school_based_campaign, goal_amount: 901)).to be_valid
    end

    it "should require the campaignable_type to be in the right set" do
      expect(build(:school_based_campaign)).to be_valid
      expect(build(:campaign, campaignable_type: 'Teacher', school_wide: false)).to be_valid
      expect(build(:campaign, campaignable: build(:teacher), campaignable_type: 'District', school_wide: false)).to_not be_valid
    end

    it "should require the campaignable_type to be present" do
      expect(build(:school_based_campaign, campaignable_type: nil)).to_not be_valid
    end

    it "should require a unique slug" do
      expect(create(:campaign, slug: '12345')).to be_valid
      expect(build(:campaign, slug: '12345')).to_not be_valid
    end

    it "should require the physical address fields" do
      [:physical_address, :physical_address_ext, :physical_city, :physical_state, :physical_postal_code].each do |attribute|
        expect(build(:campaign, "#{attribute}" => nil)).to_not be_valid
      end
    end

    it "should validate that the district is associated with the proper state" do
      utah = create(:state, name: 'Utah', abbr: 'UT')
      nevada = create(:state, name: 'Nevada', abbr: 'NV')
      district_1 = create(:district, name: 'Washington County', state: utah)
      district_2 = create(:district, name: 'Mojave County', state: nevada)
      expect(build(:campaign, state: utah, district: district_2)).to_not be_valid
    end

    it "should validate that the school is associated with the proper district" do
      utah = create(:state, name: 'Utah', abbr: 'UT')
      nevada = create(:state, name: 'Nevada', abbr: 'NV')
      washington = create(:district, name: 'Washington County', state: utah)
      mojave = create(:district, name: 'Mojave County', state: nevada)
      snow_canyon = create(:school, name: 'Snow Canyon', district: washington)
      desert_hills = create(:school, name: 'Desert Hills', district: mojave)
      expect(utah.districts).to match_array([washington])
      expect(nevada.districts).to match_array([mojave])
      expect(washington.schools).to match_array([snow_canyon])
      expect(mojave.schools).to match_array([desert_hills])
      expect(snow_canyon.state).to eq(utah)
      expect(desert_hills.state).to eq(nevada)
      expect(build(:campaign, district: washington, school: desert_hills, state: utah)).to_not be_valid
    end

    it "should NOT validate that the teacher is associated with the proper school if it is school wide" do
      utah = create(:state, name: 'Utah', abbr: 'UT')
      nevada = create(:state, name: 'Nevada', abbr: 'NV')
      washington = create(:district, name: 'Washington County', state: utah)
      mojave = create(:district, name: 'Mojave County', state: nevada)
      snow_canyon = create(:school, name: 'Snow Canyon', district: washington)
      desert_hills = create(:school, name: 'Desert Hills', district: mojave)
      teacher_1 = create(:teacher, first_name: 'Mark', last_name: 'Holmberg', school: snow_canyon)
      teacher_2 = create(:teacher, first_name: 'Scott', last_name: 'Holmberg', school: desert_hills)
      expect(utah.districts).to match_array([washington])
      expect(nevada.districts).to match_array([mojave])
      expect(washington.schools).to match_array([snow_canyon])
      expect(mojave.schools).to match_array([desert_hills])
      expect(snow_canyon.state).to eq(utah)
      expect(desert_hills.state).to eq(nevada)
      expect(snow_canyon.teachers).to match_array([teacher_1])
      expect(desert_hills.teachers).to match_array([teacher_2])
      expect(build(:campaign, district: washington, school: snow_canyon, state: utah, campaignable: teacher_2, school_wide: true)).to be_valid
    end

    it "should validate that the teacher is associated with the proper school if it is NOT school wide" do
      utah = create(:state, name: 'Utah', abbr: 'UT')
      nevada = create(:state, name: 'Nevada', abbr: 'NV')
      washington = create(:district, name: 'Washington County', state: utah)
      mojave = create(:district, name: 'Mojave County', state: nevada)
      snow_canyon = create(:school, name: 'Snow Canyon', district: washington)
      desert_hills = create(:school, name: 'Desert Hills', district: mojave)
      teacher_1 = create(:teacher, first_name: 'Mark', last_name: 'Holmberg', school: snow_canyon)
      teacher_2 = create(:teacher, first_name: 'Scott', last_name: 'Holmberg', school: desert_hills)
      expect(utah.districts).to match_array([washington])
      expect(nevada.districts).to match_array([mojave])
      expect(washington.schools).to match_array([snow_canyon])
      expect(mojave.schools).to match_array([desert_hills])
      expect(snow_canyon.state).to eq(utah)
      expect(desert_hills.state).to eq(nevada)
      expect(snow_canyon.teachers).to match_array([teacher_1])
      expect(desert_hills.teachers).to match_array([teacher_2])
      expect(build(:campaign, district: washington, school: snow_canyon, state: utah, campaignable: teacher_2, school_wide: false)).to_not be_valid
    end

    it "should only let them have a single, active school_based campaign" do
      school = create(:school, name: 'Snow Canyon')
      expect(create(:campaign, school_wide: true, active: true, campaignable: school, school: school, district: school.district, state: school.district.state)).to be_valid
      expect(build(:campaign, school_wide: true, active: true, campaignable: school, school: school, district: school.district, state: school.district.state)).to_not be_valid
      expect(build(:campaign, school_wide: true, active: false, campaignable: school, school: school, district: school.district, state: school.district.state)).to be_valid
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
      campaign = create(:campaign, district: district, state: district.state)
      expect(campaign.district).to eql(district)
    end

    it "should belong to a school" do
      school = create(:school, name: 'Snow Canyon')
      campaign = create(:campaign, school: school, district: school.district, state: school.state)
      expect(campaign.school).to eql(school)
    end

    it "should belong to a campaignable for a teacher" do
      teacher = create(:teacher, first_name: 'Mark', last_name: 'Holmberg')
      campaign = create(:campaign, campaignable: teacher, school: teacher.school, district: teacher.school.district, state: teacher.school.district.state, school_wide: false)
      expect(campaign.campaignable).to eql(teacher)
    end

    it "should belong to a campaignable for a school" do
      snow_canyon = create(:school, name: 'Snow Canyon')
      campaign = create(:campaign, campaignable: snow_canyon, school: snow_canyon, district: snow_canyon.district, state: snow_canyon.district.state, school_wide: true)
      expect(campaign.campaignable).to eql(snow_canyon)
    end

    it "should have many contributions" do
      campaign = create(:campaign)
      contribution_1 = create(:contribution, campaign: campaign)
      contribution_2 = create(:contribution, campaign: campaign)
      expect(campaign.contributions).to match_array([contribution_1, contribution_2])
    end

    it "should belong to a product" do
      product = create(:product, name: 'Hammer')
      campaign = create(:campaign, product: product)
      expect(campaign.product).to eql(product)
    end

    it "should have many impressions" do
      campaign = create(:campaign)
      impression_1 = create(:impression, campaign: campaign)
      impression_2 = create(:impression, campaign: campaign)
      expect(campaign.impressions).to match_array([impression_1, impression_2])
    end
  end

  describe "concerning instance methods" do
    it "should have a campaignable_types method" do
      expect(Campaign.campaignable_types).to match_array(['School', 'Teacher'])
    end
  end

  describe "concerning ActiveRecord callbacks" do
    it "should generate a unique slug" do
      expect(create(:campaign).slug).to_not be_nil
    end

    it "should not be destroyable if it is active?" do
      campaign = create(:campaign, name: 'Campaign', active: true)
      expect {
        campaign.destroy
      }.to_not change(Campaign, :count)
    end

    it "should not be destroyable if it has contributions" do
      campaign = create(:campaign, name: 'Campaign', active: false)
      contribution = create(:contribution, campaign: campaign)
      expect {
        campaign.destroy
      }.to_not change(Campaign, :count)
    end

    it "should copy over the goal_amount_cents from the product" do
      product = create(:product, price_dollars: 13.37)
      campaign = build(:campaign, name: 'Campaign', product: product, goal_amount_cents: 1)
      campaign.save
      campaign.reload
      expect(campaign.goal_amount.cents).to eql(1337)
    end
  end

  describe "concerning scopes" do
    it "should have a teacher_based scope" do
      yes = create(:campaign, name: 'Teacher Based', school_wide: false)
      no = create(:campaign, name: 'School Based', school_wide: true)
      expect(Campaign.teacher_based).to match_array([yes])
    end

    it "should have a school_based scope" do
      yes = create(:campaign, name: 'School Based', school_wide: true)
      no = create(:campaign, name: 'Teacher Based', school_wide: false)
      expect(Campaign.school_based).to match_array([yes])
    end
  end

  describe "concerning the nightmare of handling US Dollars" do
    context "is a nightmare every time" do
      it { expect(true).to eq(true) }
    end

    it "should invoke a call to the monetize gem" do
      expect(create(:campaign)).to monetize(:goal_amount_cents)
    end

    it "should be using USD for the currency" do
      expect(create(:campaign)).to monetize(:goal_amount_cents).with_currency(:usd)
    end

    it "can set the amount in dollars using goal_amount_dollars=" do
      campaign = create(:campaign)
      campaign.goal_amount_dollars = 13.37
      campaign.save
      expect(campaign.goal_amount.dollars).to eq(13.37)
    end
  end

  describe "concerning being converted to JSON" do
    it "should work properly" do
      campaign = create(:campaign, name: 'Campaign 1', active: true, school_wide: false, goal_amount_cents: 1337)
      result = {
        name: campaign.name,
        permalink: campaign.permalink,
        goal_amount_cents: campaign.goal_amount_cents,
      }
      expect(campaign.to_json).to eq(result.to_json)
    end
  end

  describe "concerning finding campaigns by their slug" do
    it "should find them by their slug" do
      expect(create(:campaign, slug: '12345').to_param).to eq('12345')
    end
  end

  describe "concerning the contributable? status of a campaign" do
    it "should only allow active campaigns to be contributable?" do
      expect(build(:campaign, goal_amount_cents: 500, active: true).contributable?).to eq(true)
      expect(build(:school_based_campaign, goal_amount_cents: 500, active: true).contributable?).to eq(true)
      expect(build(:campaign, goal_amount_cents: 500, active: false).contributable?).to eq(false)
      expect(build(:school_based_campaign, goal_amount_cents: 500, active: false).contributable?).to eq(false)
    end

    it "should allow active school_based cmapaigns to always be contributable?" do
      expect(build(:school_based_campaign, goal_amount_cents: 100000, active: true).contributable?).to eq(true)
      expect(build(:school_based_campaign, goal_amount_cents: 100000, active: false).contributable?).to eq(false)
    end

    it "should allow active teacher based campaigns to be contributable? if they havent met their goal" do
      product = create(:product, price_cents: 500)
      campaign = create(:campaign, product: product, active: true)
      contribution_1 = create(:contribution, amount_cents: 100, campaign: campaign)
      expect(campaign.contributions.pluck(:amount_cents).sum).to eq(100)
      expect(campaign.contributable?).to eq(true)
    end

    it "should NOT allow active teacher based campaigns to be contributable? if they have met their goal" do
      campaign = create(:campaign, goal_amount_cents: 500, active: true)
      contribution_1 = create(:contribution, amount_cents: 100, campaign: campaign)
      contribution_2 = create(:contribution, amount_cents: 200, campaign: campaign)
      contribution_3 = create(:contribution, amount_cents: 400, campaign: campaign)
      expect(campaign.contributions.pluck(:amount_cents).sum).to eq(700)
      expect(campaign.contributable?).to eq(false)
    end
  end

end
