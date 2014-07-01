require 'rails_helper'

RSpec.describe Master::TeachersController, type: :controller do

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
    @school = create(:school, name: 'Snow Canyon')
  end

  # This should return the minimal set of attributes required to create a valid
  # Teacher. As you add validations to Teacher, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:teacher).merge(school_id: @school.id)
  }

  let(:invalid_attributes) {
    {
      first_name: "",
      last_name: nil,
      school: nil,
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TeachersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all teachers as @teachers" do
      teacher = Teacher.create! valid_attributes
      get :index, {school_id: @school.to_param}, valid_session
      expect(assigns(:teachers)).to eq([teacher])
    end
  end

  describe "GET show" do
    it "assigns the requested teacher as @teacher" do
      teacher = Teacher.create! valid_attributes
      get :show, {school_id: @school.to_param, id: teacher.to_param}, valid_session
      expect(assigns(:teacher)).to eq(teacher)
      expect(assigns(:campaigns)).to match_array([])
      expect(assigns(:contributions)).to match_array([])
    end
  end

  describe "GET new" do
    it "assigns a new teacher as @teacher" do
      get :new, {school_id: @school.to_param}, valid_session
      expect(assigns(:teacher)).to be_a_new(Teacher)
    end
  end

  describe "GET edit" do
    it "assigns the requested teacher as @teacher" do
      teacher = Teacher.create! valid_attributes
      get :edit, {school_id: @school.to_param, id: teacher.to_param}, valid_session
      expect(assigns(:teacher)).to eq(teacher)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Teacher" do
        expect {
          post :create, {school_id: @school.to_param, teacher: valid_attributes}, valid_session
        }.to change(Teacher, :count).by(1)
      end

      it "assigns a newly created teacher as @teacher" do
        post :create, {school_id: @school.to_param, teacher: valid_attributes}, valid_session
        expect(assigns(:teacher)).to be_a(Teacher)
        expect(assigns(:teacher)).to be_persisted
      end

      it "redirects to the created teacher" do
        post :create, {school_id: @school.to_param, teacher: valid_attributes}, valid_session
        expect(response).to redirect_to(school_teacher_url(@school, Teacher.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved teacher as @teacher" do
        post :create, {school_id: @school.to_param, teacher: invalid_attributes}, valid_session
        expect(assigns(:teacher)).to be_a_new(Teacher)
      end

      it "re-renders the 'new' template" do
        post :create, {school_id: @school.to_param, teacher: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          first_name: 'Mark',
          last_name: 'Holmberg',
        }
      }

      it "updates the requested teacher" do
        teacher = Teacher.create! valid_attributes
        put :update, {school_id: @school.to_param, id: teacher.to_param, teacher: new_attributes}, valid_session
        teacher.reload
        expect(teacher.first_name).to eql('Mark')
        expect(teacher.last_name).to eql('Holmberg')
      end

      it "assigns the requested teacher as @teacher" do
        teacher = Teacher.create! valid_attributes
        put :update, {school_id: @school.to_param, id: teacher.to_param, teacher: valid_attributes}, valid_session
        expect(assigns(:teacher)).to eq(teacher)
      end

      it "redirects to the teacher" do
        teacher = Teacher.create! valid_attributes
        put :update, {school_id: @school.to_param, id: teacher.to_param, teacher: valid_attributes}, valid_session
        expect(response).to redirect_to(school_teacher_url(@school, teacher))
      end
    end

    describe "with invalid params" do
      it "assigns the teacher as @teacher" do
        teacher = Teacher.create! valid_attributes
        put :update, {school_id: @school.to_param, id: teacher.to_param, teacher: invalid_attributes}, valid_session
        expect(assigns(:teacher)).to eq(teacher)
      end

      it "re-renders the 'edit' template" do
        teacher = Teacher.create! valid_attributes
        put :update, {school_id: @school.to_param, id: teacher.to_param, teacher: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested teacher" do
      teacher = Teacher.create! valid_attributes
      expect {
        delete :destroy, {school_id: @school.to_param, id: teacher.to_param}, valid_session
      }.to change(Teacher, :count).by(-1)
    end

    it "redirects to the teachers list" do
      teacher = Teacher.create! valid_attributes
      delete :destroy, {school_id: @school.to_param, id: teacher.to_param}, valid_session
      expect(response).to redirect_to(school_teachers_url(@school))
    end
  end

end
