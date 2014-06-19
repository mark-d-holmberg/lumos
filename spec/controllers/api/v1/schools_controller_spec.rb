require 'rails_helper'

RSpec.describe Api::V1::SchoolsController, type: :controller do

  before(:each) do
    @district = create(:district)
  end

  # This should return the minimal set of attributes required to create a valid
  # School. As you add validations to School, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:school).merge(district_id: @district.id)
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SchoolsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all schools as @schools" do
      school = School.create! valid_attributes
      get :index, {format: :json}, valid_session
      expect(assigns(:schools)).to eq([school])
    end
  end

end
