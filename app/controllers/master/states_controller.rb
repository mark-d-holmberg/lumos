class Master::StatesController < MasterController
  before_action :set_state, only: [:show, :edit, :update, :destroy]

  def index
    @states = State.all
    @states = @states.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    if params[:search].try(:[], :sorty).present?
      @states = @states.sorty_order(sort_column, sort_direction)
    else
      @states = @states.ordered
    end
    @states = @states.page(params[:page])
  end

  def show
    @districts = @state.districts.ordered.page(params[:districts_page])
    @campaigns = @state.campaigns.ordered.page(params[:campaigns_page])
  end

  def new
    @state = State.new
  end

  def edit
  end

  def create
    @state = State.new(safe_params)

    if @state.save
      redirect_to state_url(@state), notice: 'State was successfully created.'
    else
      render :new
    end
  end

  def update
    if @state.update(safe_params)
      redirect_to state_url(@state), notice: 'State was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @state.destroy
    redirect_to states_url, notice: 'State was successfully removed.'
  end


  private

  def set_state
    @state = State.find_by(abbr: params[:id])
  end

  def safe_params
    params.require(:state).permit(:name, :abbr)
  end

end
