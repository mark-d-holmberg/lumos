class Api::V1::SchoolsController < ApiController
  before_action :load_district

  respond_to :json

  def index
    @schools = @district.schools.ordered

    # Scope this
    if params.try(:[], :scoped).present?
      @schools = @schools.with_campaigns
    end

    respond_to do |format|
      format.html { render text: "Format not supported!" }
      format.json { render json: @schools.to_json }
    end
  end


  private

  def load_district
    @district = District.find(params[:district_id])
  end

end
