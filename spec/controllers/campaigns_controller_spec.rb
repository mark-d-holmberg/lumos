require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  before(:each) do
    @state = create(:state, name: 'Utah', abbr: 'UT')
    @district = create(:district, name: 'Washington County', state: @state)
    @school = create(:school, name: 'Snow Canyon', district: @district)
    @teacher = create(:teacher, first_name: 'Mark', last_name: 'Holmberg', school: @school)
  end

  # This should return the minimal set of attributes required to create a valid
  # Campaign. As you add validations to Campaign, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:campaign).merge({
      state_id: @state.id,
      district_id: @district.id,
      school_id: @school.id,
      campaignable_id: @teacher.id,
      campaignable_type: 'Teacher',
      goal_amount_dollars: 1.00,
    })
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CampaignsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET show" do
    it "assigns the requested campaign as @campaign" do
      campaign = Campaign.create! valid_attributes
      get :show, {slug: campaign.slug}, valid_session
      expect(assigns(:campaign)).to eq(campaign)
    end
  end

end
