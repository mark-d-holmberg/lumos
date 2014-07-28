require 'rails_helper'

RSpec.describe Master::CampaignRequestsController, type: :controller do

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
    @state = create(:state, name: 'Utah', abbr: 'UT')
  end

  # This should return the minimal set of attributes required to create a valid
  # CampaignRequest. As you add validations to CampaignRequest, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:campaign_request).merge({state_id: @state.id})
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

  describe "GET index" do
    it "assigns all campaign_requests as @campaign_requests" do
      campaign_request = CampaignRequest.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:campaign_requests)).to eq([campaign_request])
    end
  end

  describe "GET show" do
    it "assigns the requested campaign_request as @campaign_request" do
      campaign_request = CampaignRequest.create! valid_attributes
      get :show, {slug: campaign_request.to_param}, valid_session
      expect(assigns(:campaign_request)).to eq(campaign_request)
    end
  end

  describe "GET edit" do
    it "assigns the requested campaign_request as @campaign_request" do
      campaign_request = CampaignRequest.create! valid_attributes
      get :edit, {slug: campaign_request.to_param}, valid_session
      expect(assigns(:campaign_request)).to eq(campaign_request)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          school_name: 'Snow Canyon',
        }
      }

      it "updates the requested campaign_request" do
        campaign_request = CampaignRequest.create! valid_attributes
        put :update, {slug: campaign_request.to_param, campaign_request: new_attributes}, valid_session
        campaign_request.reload
        expect(campaign_request.school_name).to eql('Snow Canyon')
      end

      it "assigns the requested campaign_request as @campaign_request" do
        campaign_request = CampaignRequest.create! valid_attributes
        put :update, {slug: campaign_request.to_param, campaign_request: valid_attributes}, valid_session
        expect(assigns(:campaign_request)).to eq(campaign_request)
      end

      it "redirects to the campaign_request" do
        campaign_request = CampaignRequest.create! valid_attributes
        put :update, {slug: campaign_request.to_param, campaign_request: valid_attributes}, valid_session
        expect(response).to redirect_to(campaign_request)
      end
    end

    describe "with invalid params" do
      it "assigns the campaign_request as @campaign_request" do
        campaign_request = CampaignRequest.create! valid_attributes
        put :update, {slug: campaign_request.to_param, campaign_request: invalid_attributes}, valid_session
        expect(assigns(:campaign_request)).to eq(campaign_request)
      end

      it "re-renders the 'edit' template" do
        campaign_request = CampaignRequest.create! valid_attributes
        put :update, {slug: campaign_request.to_param, campaign_request: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested campaign_request" do
      campaign_request = CampaignRequest.create! valid_attributes
      expect {
        delete :destroy, {slug: campaign_request.to_param}, valid_session
      }.to change(CampaignRequest, :count).by(-1)
    end

    it "redirects to the campaign_requests list" do
      campaign_request = CampaignRequest.create! valid_attributes
      delete :destroy, {slug: campaign_request.to_param}, valid_session
      expect(response).to redirect_to(campaign_requests_url)
    end
  end

end
