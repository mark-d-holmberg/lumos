require 'rails_helper'

RSpec.describe Master::TosController, type: :controller do

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
  end

  # This should return the minimal set of attributes required to create a valid
  # Tos. As you add validations to To, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:tos)
  }

  let(:invalid_attributes) {
    {
      content: "",
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TosController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET show" do
    it "assigns the requested tos as @tos" do
      tos = Tos.create! valid_attributes
      get :show, {}, valid_session
      expect(assigns(:tos)).to eq(tos)
    end
  end

  describe "GET edit" do
    it "assigns the requested tos as @tos" do
      tos = Tos.create! valid_attributes
      get :edit, {}, valid_session
      expect(assigns(:tos)).to eq(tos)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          content: 'New Content',
        }
      }

      it "updates the requested tos" do
        tos = Tos.create! valid_attributes
        put :update, {tos: new_attributes}, valid_session
        tos.reload
        expect(tos.content).to eql("New Content")
      end

      it "assigns the requested tos as @tos" do
        tos = Tos.create! valid_attributes
        put :update, {tos: valid_attributes}, valid_session
        expect(assigns(:tos)).to eq(tos)
      end

      it "redirects to the tos" do
        tos = Tos.create! valid_attributes
        put :update, {tos: valid_attributes}, valid_session
        expect(response).to redirect_to(tos_path)
      end
    end

    describe "with invalid params" do
      it "assigns the tos as @tos" do
        tos = Tos.create! valid_attributes
        put :update, {tos: invalid_attributes}, valid_session
        expect(assigns(:tos)).to eq(tos)
      end

      it "re-renders the 'edit' template" do
        tos = Tos.create! valid_attributes
        put :update, {tos: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

end
