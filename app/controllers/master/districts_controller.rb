class Master::DistrictsController < MasterController
  before_action :set_state
  before_action :set_district, only: [:show, :edit, :update, :destroy]

  def index
    @districts = @state.districts
    @districts = @districts.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    if params[:search].try(:[], :sorty).present?
      @districts = @districts.sorty_order(sort_column, sort_direction)
    else
      @districts = @districts.ordered
    end
    @districts = @districts.page(params[:page])
    @campaigns = @state.campaigns.ordered.page(params[:campaigns_page])
  end

  def show
    @schools = @district.schools.ordered.page(params[:schools_page])
    @campaigns = @district.campaigns.ordered.page(params[:campaigns_page])
  end

  def new
    @district = @state.districts.new
  end

  def edit
  end

  def create
    @district = @state.districts.new(safe_params)

    if @district.save
      redirect_to state_district_url(@state, @district), notice: 'District was successfully created.'
    else
      render :new
    end
  end

  def update
    if @district.update(safe_params)
      redirect_to state_district_url(@state, @district), notice: 'District was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @district.destroy
    redirect_to state_districts_url(@state), notice: 'District was successfully removed.'
  end


  private

  def set_state
    @state = State.find_by(abbr: params[:state_id])
  end

  def set_district
    @district = @state.districts.find(params[:id])
  end

  def safe_params
    params.require(:district).permit(:name, :state_id)
  end

end
