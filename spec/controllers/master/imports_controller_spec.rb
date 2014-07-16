require 'rails_helper'

RSpec.describe Master::ImportsController, type: :controller do
  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
  end

  let(:valid_session) { {} }

  describe "GET schools" do
    it "returns HTTP success" do
      get :schools, {}, valid_session
      expect(response).to be_success
    end
  end

  describe "GET indiegogo" do
    it "returns HTTP success" do
      get :indiegogo, {}, valid_session
      expect(response).to be_success
    end
  end

end
