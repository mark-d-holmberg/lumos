require 'rails_helper'

RSpec.describe CampaignRequestsController, type: :controller do
  before(:each) do
    @state = create(:state, name: 'Utah', abbr: 'UT')
    @product = create(:product, name: 'Hammer')
  end

  # This should return the minimal set of attributes required to create a valid
  # CampaignRequest. As you add validations to CampaignRequest, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:campaign_request).merge({state_id: @state.id, product_id: @product.id})
  }

  let(:invalid_attributes) {
    {
      state_id: nil,
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CampaignRequestsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET show" do
    it "assigns the requested campaign_request as @campaign_request" do
      campaign_request = CampaignRequest.create! valid_attributes
      get :show, {slug: campaign_request.to_param}, valid_session
      expect(assigns(:campaign_request)).to eq(campaign_request)
    end
  end

  describe "GET new" do
    it "assigns a new campaign_request as @campaign_request" do
      get :new, {}, valid_session
      expect(assigns(:campaign_request)).to be_a_new(CampaignRequest)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new CampaignRequest" do
        expect {
          post :create, {campaign_request: valid_attributes}, valid_session
        }.to change(CampaignRequest, :count).by(1)
      end

      it "assigns a newly created campaign_request as @campaign_request" do
        post :create, {campaign_request: valid_attributes}, valid_session
        expect(assigns(:campaign_request)).to be_a(CampaignRequest)
        expect(assigns(:campaign_request)).to be_persisted
      end

      it "redirects to the created campaign_request" do
        post :create, {campaign_request: valid_attributes}, valid_session
        expect(response).to redirect_to(CampaignRequest.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved campaign_request as @campaign_request" do
        post :create, {campaign_request: invalid_attributes}, valid_session
        expect(assigns(:campaign_request)).to be_a_new(CampaignRequest)
      end

      it "re-renders the 'new' template" do
        post :create, {campaign_request: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

end
