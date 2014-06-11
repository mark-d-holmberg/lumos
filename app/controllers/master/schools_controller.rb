class Master::SchoolsController < MasterController
  before_action :set_school, only: [:show, :edit, :update, :destroy]

  def index
    @schools = School.all
    @schools = @schools.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    if params[:search].try(:[], :sorty).present?
      @schools = @schools.sorty_order(sort_column, sort_direction)
    else
      @schools = @schools.ordered
    end
    @schools = @schools.page(params[:page])
  end

  def show
  end

  def new
    @school = School.new
  end

  def edit
  end

  def create
    @school = School.new(safe_params)

    if @school.save
      redirect_to schools_url, notice: 'School was successfully created.'
    else
      render :new
    end
  end

  def update
    if @school.update(safe_params)
      redirect_to schools_url, notice: 'School was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @school.destroy
    redirect_to schools_url, notice: 'School was successfully removed.'
  end


  private

  def set_school
    @school = School.find(params[:id])
  end

  def safe_params
    params.require(:school).permit(:name, :district_id)
  end

end
