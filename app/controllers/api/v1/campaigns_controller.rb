class Api::V1::CampaignsController < ApiController
  before_action :load_school

  respond_to :json

  def index
    @campaigns = @school.campaigns.active.ordered
    respond_to do |format|
      format.html { render text: "Format not supported!" }
      format.json { render json: @campaigns.to_json }
    end
  end


  private

  def load_school
    @district = District.find(params[:district_id])
    @school = @district.schools.find(params[:school_id])
  end

end
