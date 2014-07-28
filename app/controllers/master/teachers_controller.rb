class Master::TeachersController < MasterController
  before_action :set_school
  before_action :set_teacher, only: [:show, :edit, :update, :destroy, :reassign]

  def index
    @teachers = @school.teachers
    @teachers = @teachers.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    if params[:search].try(:[], :sorty).present?
      @teachers = @teachers.sorty_order(sort_column, sort_direction)
    else
      @teachers = @teachers.ordered
    end
    @teachers = @teachers.page(params[:teachers_page])
    @school_based_campaigns = @school.school_wide_campaigns.ordered.page(params[:campaigns_page])
  end

  def show
    @campaigns = @teacher.campaigns.ordered.page(params[:campaigns_page])
    @contributions = @teacher.contributions.ordered.page(params[:contributions_page])
  end

  def new
    @teacher = @school.teachers.new
  end

  def edit
  end

  def create
    @teacher = @school.teachers.new(safe_params)

    if @teacher.save
      redirect_to school_teacher_url(@school, @teacher), notice: 'Teacher was successfully created.'
    else
      render :new
    end
  end

  def update
    if @teacher.update(safe_params)
      redirect_to school_teacher_url(@school, @teacher), notice: 'Teacher was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @teacher.destroy
    redirect_to school_teachers_url, notice: 'Teacher was successfully removed.'
  end

  def reassign
    if request.post?
      # Update the information
      @new_school = @teacher.reassign(reassign_params)

      if @new_school
        redirect_to school_teacher_url(@new_school, @teacher), notice: 'Teacher was successfully reassigned.'
      else
        render :reassign
      end
    else
      # GET stuff here
    end
  end


  private

  def set_school
    @school = School.find(params[:school_id])
  end

  def set_teacher
    @teacher = @school.teachers.find(params[:id])
  end

  def safe_params
    params.require(:teacher).permit(:first_name, :last_name, :email, :prefix)
  end

  def reassign_params
    params.require(:reassign).permit(:new_school_id)
  end

end
