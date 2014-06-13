require 'rails_helper'

RSpec.describe Tos, type: :model do
  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:tos)).to be_valid
    end

    it "should require the content" do
      expect(build(:tos, content: nil)).to_not be_valid
    end

    it "should only let one be created" do
      tos_1 = create(:tos, content: 'Content')
      expect(tos_1).to be_valid
      expect(tos_1).to be_persisted
      expect(Tos.count).to eq(1)
      expect(build(:tos)).to_not be_valid
    end
  end
end
