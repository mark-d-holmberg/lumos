class MasterAjax::Schools::CampaignsController < MasterAjaxController

  before_action :set_school

  def new
    @campaign = @school.campaigns.new(school_wide: true)
  end

  def create
    @campaign = @school.campaigns.new(safe_params)
    @campaign.setup_school_campaign

    if @campaign.save
      flash.now[:notice] = "School Based Campaign was created successfully"
    else
      flash.now[:danger] = "errors: #{@campaign.errors.full_messages.to_sentence}"
    end
  end


  private

  def set_school
    @school = School.find(params[:school_id])
  end

  def safe_params
    safe_attributes = [
      :name,
      :product_id,
      :physical_address,
      :physical_address_ext,
      :physical_city,
      :physical_state,
      :physical_postal_code,
      :active,
    ]
    params.require(:campaign).permit(safe_attributes)
  end

end
