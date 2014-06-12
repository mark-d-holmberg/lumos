require 'rails_helper'

RSpec.describe Master::ContributorsController, type: :controller do

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
  end

  # This should return the minimal set of attributes required to create a valid
  # Contributor. As you add validations to Contributor, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:contributor)
  }

  let(:invalid_attributes) {
    {
      name: "",
      email: "",
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ContributorsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all contributors as @contributors" do
      contributor = Contributor.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:contributors)).to eq([contributor])
    end
  end

  describe "GET show" do
    it "assigns the requested contributor as @contributor" do
      contributor = Contributor.create! valid_attributes
      get :show, {id: contributor.to_param}, valid_session
      expect(assigns(:contributor)).to eq(contributor)
    end
  end

  describe "GET new" do
    it "assigns a new contributor as @contributor" do
      get :new, {}, valid_session
      expect(assigns(:contributor)).to be_a_new(Contributor)
    end
  end

  describe "GET edit" do
    it "assigns the requested contributor as @contributor" do
      contributor = Contributor.create! valid_attributes
      get :edit, {id: contributor.to_param}, valid_session
      expect(assigns(:contributor)).to eq(contributor)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Contributor" do
        expect {
          post :create, {contributor: valid_attributes}, valid_session
        }.to change(Contributor, :count).by(1)
      end

      it "assigns a newly created contributor as @contributor" do
        post :create, {contributor: valid_attributes}, valid_session
        expect(assigns(:contributor)).to be_a(Contributor)
        expect(assigns(:contributor)).to be_persisted
      end

      it "redirects to the created contributor" do
        post :create, {contributor: valid_attributes}, valid_session
        expect(response).to redirect_to(Contributor.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved contributor as @contributor" do
        post :create, {contributor: invalid_attributes}, valid_session
        expect(assigns(:contributor)).to be_a_new(Contributor)
      end

      it "re-renders the 'new' template" do
        post :create, {contributor: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          name: "Mark Holmberg",
          email: "mark@example.com",
        }
      }

      it "updates the requested contributor" do
        contributor = Contributor.create! valid_attributes
        put :update, {id: contributor.to_param, contributor: new_attributes}, valid_session
        contributor.reload
        expect(contributor.name).to eql("Mark Holmberg")
        expect(contributor.email).to eql("mark@example.com")
      end

      it "assigns the requested contributor as @contributor" do
        contributor = Contributor.create! valid_attributes
        put :update, {id: contributor.to_param, contributor: valid_attributes}, valid_session
        expect(assigns(:contributor)).to eq(contributor)
      end

      it "redirects to the contributor" do
        contributor = Contributor.create! valid_attributes
        put :update, {id: contributor.to_param, contributor: valid_attributes}, valid_session
        expect(response).to redirect_to(contributor)
      end
    end

    describe "with invalid params" do
      it "assigns the contributor as @contributor" do
        contributor = Contributor.create! valid_attributes
        put :update, {id: contributor.to_param, contributor: invalid_attributes}, valid_session
        expect(assigns(:contributor)).to eq(contributor)
      end

      it "re-renders the 'edit' template" do
        contributor = Contributor.create! valid_attributes
        put :update, {id: contributor.to_param, contributor: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested contributor" do
      contributor = Contributor.create! valid_attributes
      expect {
        delete :destroy, {id: contributor.to_param}, valid_session
      }.to change(Contributor, :count).by(-1)
    end

    it "redirects to the contributors list" do
      contributor = Contributor.create! valid_attributes
      delete :destroy, {id: contributor.to_param}, valid_session
      expect(response).to redirect_to(contributors_url)
    end
  end

end
