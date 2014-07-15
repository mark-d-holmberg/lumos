require 'rails_helper'

RSpec.describe Master::SearchesController, type: :controller do

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
  end

  let(:valid_session) { {} }

  describe "GET 'index'" do
    it "returns http success" do
      get :index, {}, valid_session
      expect(response).to be_success
    end
  end

end
