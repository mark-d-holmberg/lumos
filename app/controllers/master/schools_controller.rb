class Master::SchoolsController < MasterController
  before_action :set_district
  before_action :set_school, only: [:show, :edit, :update, :destroy]

  def index
    @schools = @district.schools
    @schools = @schools.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    if params[:search].try(:[], :sorty).present?
      @schools = @schools.sorty_order(sort_column, sort_direction)
    else
      @schools = @schools.ordered
    end
    @schools = @schools.page(params[:page])
    @campaigns = @district.campaigns.ordered.page(params[:campaigns_page])
  end

  def show
    @teachers = @school.teachers.ordered.page(params[:teachers_page])
    @school_based_campaigns = @school.school_wide_campaigns.ordered.page(params[:campaigns_page])
  end

  def new
    @school = @district.schools.new
  end

  def edit
  end

  def create
    @school = @district.schools.new(safe_params)

    if @school.save
      redirect_to district_school_url(@district, @school), notice: 'School was successfully created.'
    else
      render :new
    end
  end

  def update
    if @school.update(safe_params)
      redirect_to district_school_url(@district, @school), notice: 'School was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @school.destroy
    redirect_to district_schools_url(@district), notice: 'School was successfully removed.'
  end


  private

  def set_district
    @district = District.find(params[:district_id])
  end

  def set_school
    @school = @district.schools.find(params[:id])
  end

  def safe_params
    params.require(:school).permit(:name)
  end

end
