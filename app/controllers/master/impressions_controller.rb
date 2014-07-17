class Master::ImpressionsController < MasterController
  before_action :set_campaign
  before_action :set_impression, only: [:show, :edit, :update, :destroy]

  def index
    @impressions = @campaign.impressions.ordered.page(params[:page])
    @contributions = @campaign.contributions.ordered.page(params[:contributions_page])
  end

  def show
  end

  def new
    @impression = @campaign.impressions.new
  end

  def edit
  end

  def create
    @impression = @campaign.impressions.new(safe_params)

    if @impression.save
      redirect_to campaign_impressions_url(@campaign.to_param), notice: 'Impression was successfully created.'
    else
      render :new
    end
  end

  def update
    if @impression.update(safe_params)
      redirect_to campaign_impressions_url(@campaign.to_param), notice: 'Impression was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @impression.destroy
    redirect_to campaign_impressions_url(@campaign.to_param), notice: 'Impression was successfully removed.'
  end


  private

  def set_campaign
    @campaign = Campaign.find_by(slug: params[:campaign_slug])
  end

  def set_impression
    @impression = @campaign.impressions.find(params[:id])
  end

  def safe_params
    safe_attributes = [:email, :campaign_id, :referral_kind, :token]
    params.require(:impression).permit(safe_attributes)
  end

end
