require 'rails_helper'

RSpec.describe Master::DistrictsController, type: :controller do

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
    @state = create(:state)
  end

  # This should return the minimal set of attributes required to create a valid
  # District. As you add validations to District, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:district).merge(state_id: @state.id)
  }

  let(:invalid_attributes) {
    {
      name: "",
      state_id: nil,
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DistrictsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all districts as @districts" do
      district = District.create! valid_attributes
      get :index, {state_id: @state.to_param}, valid_session
      expect(assigns(:districts)).to eq([district])
    end
  end

  describe "GET show" do
    it "assigns the requested district as @district" do
      district = District.create! valid_attributes
      get :show, {state_id: @state.to_param, id: district.to_param}, valid_session
      expect(assigns(:district)).to eq(district)
      expect(assigns(:schools)).to match_array([])
    end
  end

  describe "GET new" do
    it "assigns a new district as @district" do
      get :new, {state_id: @state.to_param}, valid_session
      expect(assigns(:district)).to be_a_new(District)
    end
  end

  describe "GET edit" do
    it "assigns the requested district as @district" do
      district = District.create! valid_attributes
      get :edit, {state_id: @state.to_param, id: district.to_param}, valid_session
      expect(assigns(:district)).to eq(district)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new District" do
        expect {
          post :create, {state_id: @state.to_param, district: valid_attributes}, valid_session
        }.to change(District, :count).by(1)
      end

      it "assigns a newly created district as @district" do
        post :create, {state_id: @state.to_param, district: valid_attributes}, valid_session
        expect(assigns(:district)).to be_a(District)
        expect(assigns(:district)).to be_persisted
      end

      it "redirects to the created district" do
        post :create, {state_id: @state.to_param, district: valid_attributes}, valid_session
        expect(response).to redirect_to(state_district_url(@state, District.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved district as @district" do
        post :create, {state_id: @state.to_param, district: invalid_attributes}, valid_session
        expect(assigns(:district)).to be_a_new(District)
      end

      it "re-renders the 'new' template" do
        post :create, {state_id: @state.to_param, district: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          name: "Washington County"
        }
      }

      it "updates the requested district" do
        district = District.create! valid_attributes
        put :update, {state_id: @state.to_param, id: district.to_param, district: new_attributes}, valid_session
        district.reload
        expect(district.name).to eql("Washington County")
      end

      it "assigns the requested district as @district" do
        district = District.create! valid_attributes
        put :update, {state_id: @state.to_param, id: district.to_param, district: valid_attributes}, valid_session
        expect(assigns(:district)).to eq(district)
      end

      it "redirects to the district" do
        district = District.create! valid_attributes
        put :update, {state_id: @state.to_param, id: district.to_param, district: valid_attributes}, valid_session
        expect(response).to redirect_to(state_district_url(@state, district))
      end
    end

    describe "with invalid params" do
      it "assigns the district as @district" do
        district = District.create! valid_attributes
        put :update, {state_id: @state.to_param, id: district.to_param, district: invalid_attributes}, valid_session
        expect(assigns(:district)).to eq(district)
      end

      it "re-renders the 'edit' template" do
        district = District.create! valid_attributes
        put :update, {state_id: @state.to_param, id: district.to_param, district: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested district" do
      district = District.create! valid_attributes
      expect {
        delete :destroy, {state_id: @state.to_param, id: district.to_param}, valid_session
      }.to change(District, :count).by(-1)
    end

    it "redirects to the districts list" do
      district = District.create! valid_attributes
      delete :destroy, {state_id: @state.to_param, id: district.to_param}, valid_session
      expect(response).to redirect_to(state_districts_url(@state))
    end
  end

end
