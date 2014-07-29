require 'rails_helper'

RSpec.describe Api::V1::TeachersController, type: :controller do

  before(:each) do
    @school = create(:school)
  end

  let(:valid_attributes) {
    attributes_for(:teacher).merge(school_id: @school.id)
  }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all teachers as @teachers" do
      teacher = Teacher.create! valid_attributes
      get :index, {format: :json, school_id: @school.id}, valid_session
      expect(assigns(:teachers)).to match_array([teacher])
    end
  end

end
