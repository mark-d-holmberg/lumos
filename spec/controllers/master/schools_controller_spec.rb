require 'rails_helper'

RSpec.describe Master::SchoolsController, type: :controller do

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
    @district = create(:district)
  end

  # This should return the minimal set of attributes required to create a valid
  # School. As you add validations to School, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:school).merge(district_id: @district.id)
  }

  let(:invalid_attributes) {
    {
      name: "",
      district: nil,
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SchoolsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all schools as @schools" do
      school = School.create! valid_attributes
      get :index, {district_id: @district.to_param}, valid_session
      expect(assigns(:schools)).to eq([school])
    end
  end

  describe "GET show" do
    it "assigns the requested school as @school" do
      school = School.create! valid_attributes
      get :show, {district_id: @district.to_param, id: school.to_param}, valid_session
      expect(assigns(:school)).to eq(school)
      expect(assigns(:teachers)).to match_array([])
      expect(assigns(:school_based_campaigns)).to match_array([])
    end
  end

  describe "GET new" do
    it "assigns a new school as @school" do
      get :new, {district_id: @district.to_param}, valid_session
      expect(assigns(:school)).to be_a_new(School)
    end
  end

  describe "GET edit" do
    it "assigns the requested school as @school" do
      school = School.create! valid_attributes
      get :edit, {district_id: @district.to_param, id: school.to_param}, valid_session
      expect(assigns(:school)).to eq(school)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new School" do
        expect {
          post :create, {district_id: @district.to_param, school: valid_attributes}, valid_session
        }.to change(School, :count).by(1)
      end

      it "assigns a newly created school as @school" do
        post :create, {district_id: @district.to_param, school: valid_attributes}, valid_session
        expect(assigns(:school)).to be_a(School)
        expect(assigns(:school)).to be_persisted
      end

      it "redirects to the created school" do
        post :create, {district_id: @district.to_param, school: valid_attributes}, valid_session
        expect(response).to redirect_to(district_school_url(@district, School.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved school as @school" do
        post :create, {district_id: @district.to_param, school: invalid_attributes}, valid_session
        expect(assigns(:school)).to be_a_new(School)
      end

      it "re-renders the 'new' template" do
        post :create, {district_id: @district.to_param, school: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          name: 'Snow Canyon',
        }
      }

      it "updates the requested school" do
        school = School.create! valid_attributes
        put :update, {district_id: @district.to_param, id: school.to_param, school: new_attributes}, valid_session
        school.reload
        expect(school.name).to eql("Snow Canyon")
      end

      it "assigns the requested school as @school" do
        school = School.create! valid_attributes
        put :update, {district_id: @district.to_param, id: school.to_param, school: valid_attributes}, valid_session
        expect(assigns(:school)).to eq(school)
      end

      it "redirects to the school" do
        school = School.create! valid_attributes
        put :update, {district_id: @district.to_param, id: school.to_param, school: valid_attributes}, valid_session
        expect(response).to redirect_to(district_school_url(@district, school))
      end
    end

    describe "with invalid params" do
      it "assigns the school as @school" do
        school = School.create! valid_attributes
        put :update, {district_id: @district.to_param, id: school.to_param, school: invalid_attributes}, valid_session
        expect(assigns(:school)).to eq(school)
      end

      it "re-renders the 'edit' template" do
        school = School.create! valid_attributes
        put :update, {district_id: @district.to_param, id: school.to_param, school: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested school" do
      school = School.create! valid_attributes
      expect {
        delete :destroy, {district_id: @district.to_param, id: school.to_param}, valid_session
      }.to change(School, :count).by(-1)
    end

    it "redirects to the schools list" do
      school = School.create! valid_attributes
      delete :destroy, {district_id: @district.to_param, id: school.to_param}, valid_session
      expect(response).to redirect_to(district_schools_url(@district))
    end
  end

end
