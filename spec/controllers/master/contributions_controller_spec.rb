require 'rails_helper'

RSpec.describe Master::ContributionsController, type: :controller do

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
    @contributor = create(:contributor)
    @campaign = create(:campaign)
  end

  # This should return the minimal set of attributes required to create a valid
  # Contribution. As you add validations to Contribution, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:contribution).merge(campaign_id: @campaign.id, contributor_id: @contributor.id, amount_dollars: 1.00)
  }

  let(:invalid_attributes) {
    {
      pledge_id: nil,
      pledged_at: nil,
      contributor_id: nil,
      campaign_id: nil,
      amount_dollars: nil,
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ContributionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all contributions as @contributions" do
      contribution = Contribution.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:contributions)).to eq([contribution])
    end
  end

  describe "GET show" do
    it "assigns the requested contribution as @contribution" do
      contribution = Contribution.create! valid_attributes
      get :show, {id: contribution.to_param}, valid_session
      expect(assigns(:contribution)).to eq(contribution)
    end
  end

  describe "GET new" do
    it "assigns a new contribution as @contribution" do
      get :new, {}, valid_session
      expect(assigns(:contribution)).to be_a_new(Contribution)
    end
  end

  describe "GET edit" do
    it "assigns the requested contribution as @contribution" do
      contribution = Contribution.create! valid_attributes
      get :edit, {id: contribution.to_param}, valid_session
      expect(assigns(:contribution)).to eq(contribution)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Contribution" do
        expect {
          post :create, {contribution: valid_attributes}, valid_session
        }.to change(Contribution, :count).by(1)
      end

      it "assigns a newly created contribution as @contribution" do
        post :create, {contribution: valid_attributes}, valid_session
        expect(assigns(:contribution)).to be_a(Contribution)
        expect(assigns(:contribution)).to be_persisted
      end

      it "redirects to the created contribution" do
        post :create, {contribution: valid_attributes}, valid_session
        expect(response).to redirect_to(Contribution.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved contribution as @contribution" do
        post :create, {contribution: invalid_attributes}, valid_session
        expect(assigns(:contribution)).to be_a_new(Contribution)
      end

      it "re-renders the 'new' template" do
        post :create, {contribution: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          pledge_id: 37,
        }
      }

      it "updates the requested contribution" do
        contribution = Contribution.create! valid_attributes
        put :update, {id: contribution.to_param, contribution: new_attributes}, valid_session
        contribution.reload
        expect(contribution.pledge_id).to eql(37)
      end

      it "assigns the requested contribution as @contribution" do
        contribution = Contribution.create! valid_attributes
        put :update, {id: contribution.to_param, contribution: valid_attributes}, valid_session
        expect(assigns(:contribution)).to eq(contribution)
      end

      it "redirects to the contribution" do
        contribution = Contribution.create! valid_attributes
        put :update, {id: contribution.to_param, contribution: valid_attributes}, valid_session
        expect(response).to redirect_to(contribution)
      end
    end

    describe "with invalid params" do
      it "assigns the contribution as @contribution" do
        contribution = Contribution.create! valid_attributes
        put :update, {id: contribution.to_param, contribution: invalid_attributes}, valid_session
        expect(assigns(:contribution)).to eq(contribution)
      end

      it "re-renders the 'edit' template" do
        contribution = Contribution.create! valid_attributes
        put :update, {id: contribution.to_param, contribution: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested contribution" do
      contribution = Contribution.create! valid_attributes
      expect {
        delete :destroy, {id: contribution.to_param}, valid_session
      }.to change(Contribution, :count).by(-1)
    end

    it "redirects to the contributions list" do
      contribution = Contribution.create! valid_attributes
      delete :destroy, {id: contribution.to_param}, valid_session
      expect(response).to redirect_to(contributions_url)
    end
  end

end
