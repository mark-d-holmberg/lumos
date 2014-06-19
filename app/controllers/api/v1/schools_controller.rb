class Api::V1::SchoolsController < ApiController

  respond_to :json

  def index
    @schools = School.ordered
    respond_to do |format|
      format.html { render text: "Format not supported!" }
      format.json { render json: @schools.to_json }
    end
  end

end
