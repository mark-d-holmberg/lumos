class CampaignRequestsController < ApplicationController

  before_action :set_campaign_request, only: [:show]

  def show
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
    safe_attributes = [:state_id, :district_name, :school_name, :teacher_name, :campaign_name, :school_wide, :email]
    params.require(:campaign_request).permit(safe_attributes)
  end

end
