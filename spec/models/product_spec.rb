require 'rails_helper'

RSpec.describe Product, type: :model do

  describe "concering validations" do
    it "should have a valid factory" do
      expect(build(:product)).to be_valid
    end

    it "should require a name" do
      expect(build(:product, name: nil)).to_not be_valid
    end

    it "should require a unique name regardless of case" do
      expect(create(:product, name: 'Hammer')).to be_valid
      expect(build(:product, name: 'hammer')).to_not be_valid
      expect(build(:product, name: 'HAMMER')).to_not be_valid
    end

    it "should require a description" do
      expect(build(:product, description: nil)).to_not be_valid
    end

    it "should require the price" do
      expect(build(:product, price: nil)).to_not be_valid
    end

    it "should require a sane price" do
      expect(build(:product, price: 0)).to_not be_valid
      expect(build(:product, price: -1)).to_not be_valid
      expect(build(:product, price: 'abc')).to_not be_valid
    end
  end

  describe "concerning the nightmare of handling US Dollars" do
    context "is a nightmare every time" do
      it { expect(true).to eq(true) }
    end

    it "should invoke a call to the monetize gem" do
      expect(create(:product)).to monetize(:price_cents)
    end

    it "should be using USD for the currency" do
      expect(create(:product)).to monetize(:price_cents).with_currency(:usd)
    end

    it "can set the price in dollars using price_dollars=" do
      product = build(:product)
      product.price_dollars = 13.37
      product.save
      expect(product.price.dollars).to eq(13.37)
    end
  end

end
