class Master::DistrictsController < MasterController
  before_action :set_district, only: [:show, :edit, :update, :destroy]

  def index
    @districts = District.all
    @districts = @districts.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    if params[:search].try(:[], :sorty).present?
      @districts = @districts.sorty_order(sort_column, sort_direction)
    else
      @districts = @districts.ordered
    end
    @districts = @districts.page(params[:page])
  end

  def show
  end

  def new
    @district = District.new
  end

  def edit
  end

  def create
    @district = District.new(safe_params)

    if @district.save
      redirect_to districts_url, notice: 'District was successfully created.'
    else
      render :new
    end
  end

  def update
    if @district.update(safe_params)
      redirect_to districts_url, notice: 'District was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @district.destroy
    redirect_to districts_url, notice: 'District was successfully removed.'
  end


  private

  def set_district
    @district = District.find(params[:id])
  end

  def safe_params
    params.require(:district).permit(:name, :state_id)
  end

end
