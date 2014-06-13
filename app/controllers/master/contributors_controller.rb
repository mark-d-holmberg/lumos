class Master::ContributorsController < MasterController
  before_action :set_contributor, only: [:show, :edit, :update, :destroy]

  def index
    @contributors = Contributor.all
    @contributors = @contributors.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    if params[:search].try(:[], :sorty).present?
      @contributors = @contributors.sorty_order(sort_column, sort_direction)
    else
      @contributors = @contributors.ordered
    end
    @contributors = @contributors.page(params[:page])
  end

  def show
    @contributions = @contributor.contributions.ordered.page(params[:page])
  end

  def new
    @contributor = Contributor.new
  end

  def edit
  end

  def create
    @contributor = Contributor.new(contributor_params)

    if @contributor.save
      redirect_to @contributor, notice: 'Contributor was successfully created.'
    else
      render :new
    end
  end

  def update
    if @contributor.update(contributor_params)
      redirect_to @contributor, notice: 'Contributor was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @contributor.destroy
    redirect_to contributors_url, notice: 'Contributor was successfully removed.'
  end


  private

  def set_contributor
    @contributor = Contributor.find(params[:id])
  end

  def contributor_params
    params.require(:contributor).permit(:name, :email)
  end

end
