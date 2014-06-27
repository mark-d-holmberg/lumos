require 'rails_helper'

RSpec.describe Master::ImpressionsController, type: :controller do

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
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

  describe "GET index" do
    it "assigns all impressions as @impressions" do
      impression = Impression.create! valid_attributes
      get :index, {campaign_slug: @campaign.to_param}, valid_session
      expect(assigns(:impressions)).to eq([impression])
    end
  end

  describe "GET show" do
    it "assigns the requested impression as @impression" do
      impression = Impression.create! valid_attributes
      get :show, {campaign_slug: @campaign.to_param, id: impression.to_param}, valid_session
      expect(assigns(:impression)).to eq(impression)
    end
  end

  describe "GET new" do
    it "assigns a new impression as @impression" do
      get :new, {campaign_slug: @campaign.to_param}, valid_session
      expect(assigns(:impression)).to be_a_new(Impression)
    end
  end

  describe "GET edit" do
    it "assigns the requested impression as @impression" do
      impression = Impression.create! valid_attributes
      get :edit, {campaign_slug: @campaign.to_param, id: impression.to_param}, valid_session
      expect(assigns(:impression)).to eq(impression)
    end
  end

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
        expect(response).to redirect_to(campaign_impressions_url(@campaign.to_param))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved impression as @impression" do
        post :create, {campaign_slug: @campaign.to_param, impression: invalid_attributes}, valid_session
        expect(assigns(:impression)).to be_a_new(Impression)
      end

      it "re-renders the 'new' template" do
        post :create, {campaign_slug: @campaign.to_param, impression: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          email: 'mark@example.com',
        }
      }

      it "updates the requested impression" do
        impression = Impression.create! valid_attributes
        put :update, {campaign_slug: @campaign.to_param, id: impression.to_param, impression: new_attributes}, valid_session
        impression.reload
        expect(impression.email).to eql("mark@example.com")
      end

      it "assigns the requested impression as @impression" do
        impression = Impression.create! valid_attributes
        put :update, {campaign_slug: @campaign.to_param, id: impression.to_param, impression: valid_attributes}, valid_session
        expect(assigns(:impression)).to eq(impression)
      end

      it "redirects to the impression" do
        impression = Impression.create! valid_attributes
        put :update, {campaign_slug: @campaign.to_param, id: impression.to_param, impression: valid_attributes}, valid_session
        expect(response).to redirect_to(campaign_impressions_url(@campaign.to_param))
      end
    end

    describe "with invalid params" do
      it "assigns the impression as @impression" do
        impression = Impression.create! valid_attributes
        put :update, {campaign_slug: @campaign.to_param, id: impression.to_param, impression: invalid_attributes}, valid_session
        expect(assigns(:impression)).to eq(impression)
      end

      it "re-renders the 'edit' template" do
        impression = Impression.create! valid_attributes
        put :update, {campaign_slug: @campaign.to_param, id: impression.to_param, impression: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested impression" do
      impression = Impression.create! valid_attributes
      expect {
        delete :destroy, {campaign_slug: @campaign.to_param, id: impression.to_param}, valid_session
      }.to change(Impression, :count).by(-1)
    end

    it "redirects to the impressions list" do
      impression = Impression.create! valid_attributes
      delete :destroy, {campaign_slug: @campaign.to_param, id: impression.to_param}, valid_session
      expect(response).to redirect_to(campaign_impressions_url(@campaign.to_param))
    end
  end

end
