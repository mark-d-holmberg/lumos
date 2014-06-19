class Master::CampaignsController < MasterController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]

  def index
    @campaigns = Campaign.ordered
    @campaigns = @campaigns.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    @teacher_campaigns = @campaigns.teacher_based
    @school_campaigns = @campaigns.school_based

    if params[:search].try(:[], :sorty).present?
      @teacher_campaigns = @teacher_campaigns.sorty_order(sort_column, sort_direction, sort_polymorphic)
      @school_campaigns = @school_campaigns.sorty_order(sort_column, sort_direction, sort_polymorphic)
    end

    @teacher_campaigns = @teacher_campaigns.page(params[:teachers_page])
    @school_campaigns = @school_campaigns.page(params[:schools_page])
  end

  def show
    @contributions = @campaign.contributions.ordered.page(params[:page])
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
    @campaign = Campaign.find(params[:id])
  end

  def safe_params
    params.require(:campaign).permit(:name, :state_id, :district_id, :school_id, :campaignable_id, :campaignable_type, :active, :goal_amount_dollars)
  end

end
