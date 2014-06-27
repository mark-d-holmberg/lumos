class ImpressionsController < ApplicationController
  before_action :set_campaign

  def create
    if current_impression.present?
      redirect_to thank_you_campaign_url(@campaign.to_param, subdomain: 'landing'), notice: 'Thank you for your contributions'
    else
      @impression = @campaign.impressions.new(safe_params)
      if @impression.save
        cookies.permanent[:impression_token] = @impression.token
        redirect_to partner_campaign_url(@campaign.to_param, subdomain: 'landing')
      else
        redirect_to landing_campaign_path(@campaign.to_param, subdomain: 'landing')
      end
    end
  end


  private

  def set_campaign
    @campaign = Campaign.find_by(slug: params[:campaign_slug])
  end

  def safe_params
    safe_attributes = [:email, :referral_kind]
    params.require(:impression).permit(safe_attributes)
  end

end
