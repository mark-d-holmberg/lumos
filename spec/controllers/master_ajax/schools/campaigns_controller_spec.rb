require 'rails_helper'

RSpec.describe MasterAjax::Schools::CampaignsController, type: :controller do

  before(:each) do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(create(:user))
    @state = create(:state, name: 'Utah', abbr: 'UT')
    @district = create(:district, name: 'Washington County', state: @state)
    @school = create(:school, name: 'Snow Canyon', district: @district)
    @product = create(:product, name: 'Hammer', price_cents: 100)
  end

  let(:valid_attributes) {
    attributes_for(:campaign).merge({
      state_id: @state.id,
      district_id: @district.id,
      school_id: @school.id,
      product_id: @product.id,
      goal_amount_dollars: 1.00,
    })
  }

  let(:invalid_attributes) {
    {
      name: "",
      state: nil,
      district: nil,
      school: nil,
      campaignable: nil,
    }
  }

  let(:valid_session) { {} }

  describe "GET new" do
    it "assigns a new campaign as @campaign" do
      xhr :get, :new, {school_id: @school.to_param}, valid_session
      expect(assigns(:campaign)).to be_a_new(Campaign)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Campaign" do
        expect {
          xhr :post, :create, {format: :js, school_id: @school.to_param, campaign: valid_attributes}, valid_session
        }.to change(Campaign, :count).by(1)
      end

      it "assigns a newly created campaign as @campaign" do
        xhr :post, :create, {format: :js, school_id: @school.to_param, campaign: valid_attributes}, valid_session
        expect(assigns(:campaign)).to be_a(Campaign)
        expect(assigns(:campaign)).to be_persisted
      end

      it "renders the create template" do
        xhr :post, :create, {format: :js, school_id: @school.to_param, campaign: valid_attributes}, valid_session
        expect(response).to render_template("create")
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved campaign as @campaign" do
        xhr :post, :create, {format: :js, school_id: @school.to_param, campaign: invalid_attributes}, valid_session
        expect(assigns(:campaign)).to be_a_new(Campaign)
      end

      it "re-renders the 'create' template" do
        xhr :post, :create, {format: :js, school_id: @school.to_param, campaign: invalid_attributes}, valid_session
        expect(response).to render_template("create")
      end
    end
  end

end
