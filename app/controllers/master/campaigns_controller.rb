class Master::CampaignsController < MasterController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]

  def index
    @campaigns = Campaign.all
    @teacher_campaigns = @campaigns.teacher_based
    @school_campaigns = @campaigns.school_based

    # Search based on my criteria
    if params[:search].try(:[], :query).present?
      @teacher_campaigns = @teacher_campaigns.search(params[:search][:query])
      @school_campaigns = @school_campaigns.search(params[:search][:query])
    end

    # Order by Sorty Params
    if params[:search].try(:[], :sorty).present?
      @teacher_campaigns = @teacher_campaigns.sorty_order(sort_column, sort_direction)
      @school_campaigns = @school_campaigns.sorty_order(sort_column, sort_direction)
    else
      @teacher_campaigns = @teacher_campaigns.ordered
      @school_campaigns = @school_campaigns.ordered
    end

    # Paginate them
    @teacher_campaigns = @teacher_campaigns.page(params[:teachers_page])
    @school_campaigns = @school_campaigns.page(params[:schools_page])
  end

  def show
    @contributions = @campaign.contributions.ordered.page(params[:contributions_page])
  end

  def new
    @campaign = Campaign.new
  end

  def edit
  end

  def create
    @campaign = Campaign.new(safe_params)

    if @campaign.save
      redirect_to @campaign, notice: 'Campaign was successfully created.'
    else
      render :new
    end
  end

  def update
    if @campaign.update(safe_params)
      redirect_to @campaign, notice: 'Campaign was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @campaign.destroy
    redirect_to campaigns_url, notice: 'Campaign was successfully removed.'
  end


  private

  def set_campaign
    @campaign = Campaign.find_by(slug: params[:slug])
  end

  def safe_params
    safe_attributes = [
      :active,
      :campaignable_id,
      :campaignable_type,
      :district_id,
      :goal_amount_dollars,
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
