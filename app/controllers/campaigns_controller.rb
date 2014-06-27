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

  def thank_you
    if request.post?
      # Clear your crap here
      cookies.delete(:impression_token)
      redirect_to landing_campaign_path(@campaign.to_param, subdomain: 'landing')
    else
      # GET stuff here
    end
  end


  private

  def load_campaign
    @campaign = Campaign.active.find_by(slug: params[:slug])
  end

end
