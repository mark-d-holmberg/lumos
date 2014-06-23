require 'rails_helper'

RSpec.describe Api::V1::CampaignsController, type: :controller do

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
      active: true,
      state_id: @state.id,
      district_id: @district.id,
      school_id: @school.id,
      campaignable_id: @teacher.id,
      campaignable_type: 'Teacher',
      goal_amount_dollars: 1.00,
    })
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CampaignsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all active campaigns as @campaigns" do
      campaign = Campaign.create! valid_attributes
      get :index, {format: :json, district_id: @district.id, school_id: @school.id}, valid_session
      expect(assigns(:campaigns)).to eq([campaign])
    end
  end

end
