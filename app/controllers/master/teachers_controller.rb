class Master::TeachersController < MasterController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]

  def index
    @teachers = Teacher.all
    @teachers = @teachers.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    if params[:search].try(:[], :sorty).present?
      @teachers = @teachers.sorty_order(sort_column, sort_direction)
    else
      @teachers = @teachers.ordered
    end
    @teachers = @teachers.page(params[:page])
  end

  def show
  end

  def new
    @teacher = Teacher.new
  end

  def edit
  end

  def create
    @teacher = Teacher.new(safe_params)

    if @teacher.save
      redirect_to teachers_url, notice: 'Teacher was successfully created.'
    else
      render :new
    end
  end

  def update
    if @teacher.update(safe_params)
      redirect_to teachers_url, notice: 'Teacher was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @teacher.destroy
    redirect_to teachers_url, notice: 'Teacher was successfully removed.'
  end


  private

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end

  def safe_params
    params.require(:teacher).permit(:first_name, :last_name, :school_id)
  end

end
