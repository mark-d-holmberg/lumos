require 'rails_helper'

RSpec.describe Contribution, type: :model do
  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:contribution)).to be_valid
    end

    it "should require a pledge_id" do
      expect(build(:contribution, pledge_id: nil)).to_not be_valid
    end

    it "should require a unique pledge_id" do
      expect(create(:contribution, pledge_id: 35)).to be_valid
      expect(build(:contribution, pledge_id: 35)).to_not be_valid
    end

    it "should require a pledged_at" do
      expect(build(:contribution, pledged_at: nil)).to_not be_valid
    end

    it "should require a contributor" do
      expect(build(:contribution, contributor: nil)).to_not be_valid
    end

    it "should require a campaign" do
      expect(build(:contribution, campaign: nil)).to_not be_valid
    end

    it "should require an amount" do
      expect(build(:contribution, amount: nil)).to_not be_valid
    end

    it "should require a positive amount" do
      expect(build(:contribution, amount: 0)).to_not be_valid
      expect(build(:contribution, amount: -1)).to_not be_valid
      expect(build(:contribution, amount: 'abc')).to_not be_valid
    end

    it "should require a unique impression token" do
      expect(create(:contribution, impression_token: 12345)).to be_valid
      expect(build(:contribution, impression_token: 12345)).to_not be_valid
    end
  end

  describe "concerning the nightmare of handling US Dollars" do
    context "is a nightmare every time" do
      it { expect(true).to eq(true) }
    end

    it "should invoke a call to the monetize gem" do
      expect(create(:contribution)).to monetize(:amount_cents)
    end

    it "should be using USD for the currency" do
      expect(create(:contribution)).to monetize(:amount_cents).with_currency(:usd)
    end

    it "can set the amount in dollars using amount_dollars=" do
      contribution = build(:contribution)
      contribution.amount_dollars = 13.37
      contribution.save
      expect(contribution.amount.dollars).to eq(13.37)
    end
  end

  describe "concerning relations" do
    it "belongs to a contributor" do
      contributor = create(:contributor, name: 'Mark Holmberg')
      contribution = create(:contribution, contributor: contributor)
      expect(contribution.contributor).to eql(contributor)
    end

    it "should belong to a campaign" do
      campaign = create(:campaign, name: 'My Campaign')
      contribution = create(:contribution, campaign: campaign)
      expect(contribution.campaign).to eql(campaign)
    end
  end
end
