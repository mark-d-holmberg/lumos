require 'rails_helper'

RSpec.describe Api::V1::DistrictsController, type: :controller do

  before(:each) do
    @state = create(:state)
  end

  # This should return the minimal set of attributes required to create a valid
  # District. As you add validations to District, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:district).merge(state_id: @state.id)
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DistrictsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all districts as @districts" do
      district = District.create! valid_attributes
      get :index, {format: :json}, valid_session
      expect(assigns(:districts)).to eq([district])
    end
  end

end
