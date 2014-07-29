class Api::V1::TeachersController < ApiController
  before_action :load_school

  respond_to :json

  def index
    @teachers = @school.teachers.ordered

    # Scope this
    if params.try(:[], :scoped).present?
      @teachers = @teachers.with_campaigns
    end

    respond_to do |format|
      format.html { render text: "Format not supported!" }
      format.json { render json: @teachers.to_json }
    end
  end


  private

  def load_school
    @school = School.find(params[:school_id])
  end

end
