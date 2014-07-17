require 'rails_helper'

RSpec.describe Master::ReportsController, type: :controller do

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SchoolsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "returns HTTP success" do
      get :index, {}, valid_session
      expect(response).to be_success
    end
  end

  describe "GET pending_impressions" do
    it "returns HTTP success" do
      get :pending_impressions, {}, valid_session
      expect(response).to be_success
    end
  end

end
