class Api::V1::DistrictsController < ApiController

  respond_to :json

  def index
    @districts = District.ordered
    respond_to do |format|
      format.html { render text: "Format not supported!" }
      format.json { render json: @districts.to_json }
    end
  end

end
