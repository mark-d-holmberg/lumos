require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  before(:each) do
    @state = create(:state, name: 'Utah', abbr: 'UT')
    @district = create(:district, name: 'Washington County', state: @state)
    @school = create(:school, name: 'Snow Canyon', district: @district)
    @teacher = create(:teacher, first_name: 'Mark', last_name: 'Holmberg', school: @school)
    @product = create(:product, name: 'Hammer')
  end

  # This should return the minimal set of attributes required to create a valid
  # Campaign. As you add validations to Campaign, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:campaign).merge({
      state_id: @state.id,
      district_id: @district.id,
      school_id: @school.id,
      product_id: @product.id,
      campaignable_id: @teacher.id,
      campaignable_type: 'Teacher',
      goal_amount_dollars: 1.00,
    })
  }

  let(:invalid_attributes) {
    {
      name: "",
      state: nil,
      district: nil,
      school: nil,
      campaignable: nil,
    }
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

  describe "GET reports" do
    it "assigns the requested campaign as @campaign" do
      campaign = Campaign.create! valid_attributes
      get :reports, {slug: campaign.slug}, valid_session
      expect(assigns(:campaign)).to eq(campaign)
    end
  end

  describe "GET contributions" do
    it "assigns the requested campaign as @campaign" do
      campaign = Campaign.create! valid_attributes
      get :contributions, {slug: campaign.slug}, valid_session
      expect(assigns(:campaign)).to eq(campaign)
      expect(assigns(:contributions)).to eq([])
    end
  end

  describe "GET partner" do
    it "assigns the requested campaign as @campaign" do
      campaign = Campaign.create! valid_attributes
      get :partner, {slug: campaign.slug}, valid_session
      expect(assigns(:campaign)).to eq(campaign)
    end
  end

  describe "GET thank_you" do
    it "assigns the requested campaign as @campaign" do
      campaign = Campaign.create! valid_attributes
      get :thank_you, {slug: campaign.slug}, valid_session
      expect(assigns(:campaign)).to eq(campaign)
    end
  end

  describe "GET new" do
    it "assigns a new campaign as @campaign" do
      get :new, {}, valid_session
      expect(assigns(:campaign)).to be_a_new(Campaign)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Campaign" do
        expect {
          post :create, {campaign: valid_attributes}, valid_session
        }.to change(Campaign, :count).by(1)
      end

      it "assigns a newly created campaign as @campaign" do
        post :create, {campaign: valid_attributes}, valid_session
        expect(assigns(:campaign)).to be_a(Campaign)
        expect(assigns(:campaign)).to be_persisted
      end

      it "redirects to the created campaign" do
        post :create, {campaign: valid_attributes}, valid_session
        expect(response).to redirect_to(landing_campaign_url(Campaign.last.to_param, subdomain: 'landing'))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved campaign as @campaign" do
        post :create, {campaign: invalid_attributes}, valid_session
        expect(assigns(:campaign)).to be_a_new(Campaign)
      end

      it "re-renders the 'new' template" do
        post :create, {campaign: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

end
