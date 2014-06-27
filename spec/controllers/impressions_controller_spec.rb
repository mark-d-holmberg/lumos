require 'rails_helper'

RSpec.describe ImpressionsController, type: :controller do

  before(:each) do
    # allow(controller).to receive(:authenticate_user!).and_return(true)
    # allow(controller).to receive(:current_user).and_return(create(:user))
    @campaign = create(:campaign)
  end

  # This should return the minimal set of attributes required to create a valid
  # Impression. As you add validations to Impression, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:impression).merge(campaign_id: @campaign.id)
  }

  let(:invalid_attributes) {
    {
      email: nil,
      campaign_id: nil,
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ImpressionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Impression" do
        expect {
          post :create, {campaign_slug: @campaign.to_param, impression: valid_attributes}, valid_session
        }.to change(Impression, :count).by(1)
      end

      it "assigns a newly created impression as @impression" do
        post :create, {campaign_slug: @campaign.to_param, impression: valid_attributes}, valid_session
        expect(assigns(:impression)).to be_a(Impression)
        expect(assigns(:impression)).to be_persisted
      end

      it "redirects to the created impression" do
        post :create, {campaign_slug: @campaign.to_param, impression: valid_attributes}, valid_session
        expect(response).to redirect_to(partner_campaign_url(@campaign.to_param, subdomain: 'landing'))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved impression as @impression" do
        post :create, {campaign_slug: @campaign.to_param, impression: invalid_attributes}, valid_session
        expect(assigns(:impression)).to be_a_new(Impression)
      end

      it "re-renders the 'new' template" do
        post :create, {campaign_slug: @campaign.to_param, impression: invalid_attributes}, valid_session
        expect(response).to redirect_to(landing_campaign_path(@campaign.to_param, subdomain: 'landing'))
      end
    end
  end

end
