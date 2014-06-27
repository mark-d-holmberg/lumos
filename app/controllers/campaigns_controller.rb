class CampaignsController < ApplicationController

  before_action :load_campaign

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(safe_params)

    # Dirty, DIRTY shortcut
    @campaign.goal_amount_cents = 1

    if @campaign.save
      redirect_to landing_campaign_url(@campaign.to_param, subdomain: 'landing'), notice: 'Campaign was successfully created.'
    else
      render :new
    end
  end

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

  def safe_params
    safe_attributes = [
      :campaignable_id,
      :campaignable_type,
      :district_id,
      :name,
      :product_id,
      :school_id,
      :state_id,
      :physical_address,
      :physical_address_ext,
      :physical_city,
      :physical_state,
      :physical_postal_code,
    ]
    params.require(:campaign).permit(safe_attributes)
  end

end
