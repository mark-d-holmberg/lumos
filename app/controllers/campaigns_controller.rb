class CampaignsController < ApplicationController

  def show
    @campaign = Campaign.active.find_by(slug: params[:slug])
  end

end
