class Master::CampaignRequestsController < MasterController

  before_action :set_campaign_request, only: [:show, :edit, :update, :destroy, :convert]
  before_action :check_approved_at, only: [:edit, :update, :convert]

  def index
    @campaign_requests = CampaignRequest.not_approved.ordered.page(params[:page])
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

  def check_approved_at
    if @campaign_request.approved_at.present?
      flash[:error] = 'Cannot modify approved Campaign Requests!'
      redirect_to campaign_requests_path
    end
  end

  def set_campaign_request
    @campaign_request = CampaignRequest.find_by(slug: params[:slug])
  end

  def safe_params
    safe_attributes = [
      :campaign_name,
      :district_name,
      :email,
      :physical_address,
      :physical_address_ext,
      :physical_city,
      :physical_postal_code,
      :physical_state,
      :product_id,
      :school_name,
      :school_wide,
      :state_id,
      :teacher_first_name,
      :teacher_last_name,
    ]
    params.require(:campaign_request).permit(safe_attributes)
  end

  def convert_params
    safe_attributes = [
      :campaign_name,
      :district_name,
      :email,
      :physical_address,
      :physical_address_ext,
      :physical_city,
      :physical_postal_code,
      :physical_state,
      :product_id,
      :school_name,
      :school_wide,
      :state_id,
      :teacher_first_name,
      :teacher_last_name,
      associations: [
        :district_id,
        :school_id,
        :teacher_id,
      ]
    ]
    params.require(:convert_campaign_request).permit(safe_attributes)
  end

end
