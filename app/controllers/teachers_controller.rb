class TeachersController < ApplicationController

  respond_to :js

  before_action :load_school

  def new
    respond_to do |format|
      format.js { @teacher = @school.teachers.new }
    end
  end

  def create
    respond_to do |format|
      format.js {
        @teacher = @school.teachers.new(safe_params)
        flash.now[:notice] = 'Teacher was added successfully' if @teacher.save
      }
    end
  end


  private

  def load_school
    @school = School.find(params[:school_id])
  end

  def safe_params
    params.require(:teacher).permit(:first_name, :last_name, :school_id, :email, :prefix)
  end

end
