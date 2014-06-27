class CampaignsController < ApplicationController

  before_action :load_campaign

  def show
  end

  def reports
  end

  def contributions
    @contributions = @campaign.contributions.ordered.page(params[:page])
  end

  def partner
  end


  private

  def load_campaign
    @campaign = Campaign.active.find_by(slug: params[:slug])
  end

end
