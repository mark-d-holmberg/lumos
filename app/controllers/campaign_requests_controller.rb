class CampaignRequestsController < ApplicationController

  before_action :set_campaign_request, only: [:show]

  def show
    if @campaign_request.campaign.present?
      # Redirect this stuff
      redirect_to landing_campaign_url(@campaign_request.campaign.to_param, subdomain: 'landing'), notice: 'Campaign Request was approved!'
    end
  end

  def new
    @campaign_request = CampaignRequest.new
  end

  def create
    @campaign_request = CampaignRequest.new(safe_params)

    if @campaign_request.save
      redirect_to @campaign_request, notice: 'Campaign Request was successfully created.'
    else
      render :new
    end
  end


  private

  def set_campaign_request
    @campaign_request = CampaignRequest.find_by(slug: params[:slug])
  end

  def safe_params
    safe_attributes = [
      :campaign_name,
      :district_name,
      :email,
      :physical_address,
      :physical_address_ext,
      :physical_city,
      :physical_postal_code,
      :physical_state,
      :product_id,
      :school_name,
      :school_wide,
      :state_id,
      :teacher_first_name,
      :teacher_last_name,
    ]
    params.require(:campaign_request).permit(safe_attributes)
  end

end
