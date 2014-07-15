class Master::SearchesController < MasterController

  def index
    # Teachers
    @teachers = Teacher.all
    @teachers = @teachers.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    if params[:search].try(:[], :sorty).present?
      @teachers = @teachers.sorty_order(params[:search][:sorty][:sort], sort_direction)
    else
      @teachers = @teachers.ordered
    end
    @teachers = @teachers.page(params[:teachers_page])

    # Schools
    @schools = School.all
    @schools = @schools.search(params[:search][:query]) if params[:search].try(:[], :query).present?
    if params[:search].try(:[], :sorty).present?
      @schools = @schools.sorty_order(sort_column, sort_direction)
    else
      @schools = @schools.ordered
    end
    @schools = @schools.page(params[:schools_page])
  end


  private

  def sort_column
    if params[:search].try(:[], :sorty).present?
      params[:search][:sorty][:sort]
    end
  end

end
