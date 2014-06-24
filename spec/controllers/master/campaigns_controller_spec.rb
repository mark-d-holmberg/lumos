require 'rails_helper'

RSpec.describe Master::CampaignsController, type: :controller do

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
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

  describe "GET index" do
    it "assigns all campaigns as @campaigns" do
      campaign = Campaign.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:campaigns)).to eq([campaign])
      expect(assigns(:teacher_campaigns)).to eq([campaign])
      expect(assigns(:school_campaigns)).to eq([])
    end
  end

  describe "GET show" do
    it "assigns the requested campaign as @campaign" do
      campaign = Campaign.create! valid_attributes
      get :show, {slug: campaign.to_param}, valid_session
      expect(assigns(:campaign)).to eq(campaign)
      expect(assigns(:contributions)).to eq([])
    end
  end

  describe "GET new" do
    it "assigns a new campaign as @campaign" do
      get :new, {}, valid_session
      expect(assigns(:campaign)).to be_a_new(Campaign)
    end
  end

  describe "GET edit" do
    it "assigns the requested campaign as @campaign" do
      campaign = Campaign.create! valid_attributes
      get :edit, {slug: campaign.to_param}, valid_session
      expect(assigns(:campaign)).to eq(campaign)
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
        expect(response).to redirect_to(Campaign.last)
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

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          name: 'Campaign Cool',
        }
      }

      it "updates the requested campaign" do
        campaign = Campaign.create! valid_attributes
        put :update, {slug: campaign.to_param, campaign: new_attributes}, valid_session
        campaign.reload
        expect(campaign.name).to eql('Campaign Cool')
      end

      it "assigns the requested campaign as @campaign" do
        campaign = Campaign.create! valid_attributes
        put :update, {slug: campaign.to_param, campaign: valid_attributes}, valid_session
        expect(assigns(:campaign)).to eq(campaign)
      end

      it "redirects to the campaign" do
        campaign = Campaign.create! valid_attributes
        put :update, {slug: campaign.to_param, campaign: valid_attributes}, valid_session
        expect(response).to redirect_to(campaign)
      end
    end

    describe "with invalid params" do
      it "assigns the campaign as @campaign" do
        campaign = Campaign.create! valid_attributes
        put :update, {slug: campaign.to_param, campaign: invalid_attributes}, valid_session
        expect(assigns(:campaign)).to eq(campaign)
      end

      it "re-renders the 'edit' template" do
        campaign = Campaign.create! valid_attributes
        put :update, {slug: campaign.to_param, campaign: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested campaign" do
      campaign = Campaign.create! valid_attributes.merge(active: false)
      expect {
        delete :destroy, {slug: campaign.to_param}, valid_session
      }.to change(Campaign, :count).by(-1)
    end

    it "redirects to the campaigns list" do
      campaign = Campaign.create! valid_attributes
      delete :destroy, {slug: campaign.to_param}, valid_session
      expect(response).to redirect_to(campaigns_url)
    end
  end

end
