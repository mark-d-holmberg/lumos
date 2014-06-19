class Api::V1::CampaignsController < ApiController

  respond_to :json

  def index
    @campaigns = Campaign.active.ordered
    respond_to do |format|
      format.html { render text: "Format not supported!" }
      format.json { render json: @campaigns.to_json }
    end
  end

end
