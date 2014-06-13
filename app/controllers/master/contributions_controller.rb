class Master::ContributionsController < MasterController
  before_action :set_contribution, only: [:show, :edit, :update, :destroy]

  def index
    @contributions = Contribution.all
    @contributions = @contributions.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    if params[:search].try(:[], :sorty).present?
      @contributions = @contributions.sorty_order(sort_column, sort_direction)
    else
      @contributions = @contributions.ordered
    end
    @contributions = @contributions.page(params[:page])
  end

  def show
  end

  def new
    @contribution = Contribution.new
  end

  def edit
  end

  def create
    @contribution = Contribution.new(safe_params)

    if @contribution.save
      redirect_to @contribution, notice: 'Contribution was successfully created.'
    else
      render :new
    end
  end

  def update
    if @contribution.update(safe_params)
      redirect_to @contribution, notice: 'Contribution was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @contribution.destroy
    redirect_to contributions_url, notice: 'Contribution was successfully removed.'
  end


  private

  def set_contribution
    @contribution = Contribution.find(params[:id])
  end

  def safe_params
    params.require(:contribution).permit(:pledge_id, :pledged_at, :contributor_id, :campaign_id, :amount_dollars)
  end

end
