class Api::V1::DistrictsController < ApiController

  respond_to :json

  def index
    @districts = District.ordered

    if params.try(:[], :scoped).present?
      @districts = @districts.with_schools
    end

    # Limit them by the state
    @districts = @districts.with_state(params[:state_abbr]) if params.try(:[], :state_abbr).present?

    respond_to do |format|
      format.html { render text: "Format not supported!" }
      format.json { render json: @districts.to_json }
    end
  end

end
