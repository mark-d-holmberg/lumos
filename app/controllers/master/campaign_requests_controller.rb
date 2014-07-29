class Master::CampaignRequestsController < MasterController

  before_action :set_campaign_request, only: [:show, :edit, :update, :destroy, :convert]

  def index
    @campaign_requests = CampaignRequest.ordered.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @campaign_request.update(safe_params)
      redirect_to @campaign_request, notice: 'Campaign Request was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @campaign_request.destroy
    redirect_to campaign_requests_url, notice: 'Campaign Request was successfully removed.'
  end

  def convert
    if request.post?
      if @campaign_request.convert(convert_params)
        redirect_to campaign_requests_url, notice: 'Campaign Request was successfully converted.'
      else
        render :convert
      end
    else
      # GET stuff here
    end
  end


  private

  def set_campaign_request
    @campaign_request = CampaignRequest.find_by(slug: params[:slug])
  end

  def safe_params
    safe_attributes = [:state_id, :district_name, :school_name, :teacher_name, :campaign_name, :school_wide, :email]
    params.require(:campaign_request).permit(safe_attributes)
  end

  def convert_params
    safe_attributes = [
      :state_id,
      :district_name,
      :school_name,
      :teacher_name,
      :campaign_name,
      :school_wide,
      :email,
      associations: [
        :district_id,
        :school_id,
        :teacher_id,
      ]
    ]
    params.require(:convert_campaign_request).permit(safe_attributes)
  end

end
