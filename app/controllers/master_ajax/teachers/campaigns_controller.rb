class MasterAjax::Teachers::CampaignsController < MasterAjaxController

  before_action :set_teacher

  def new
    @campaign = @teacher.campaigns.new(school_wide: false)
  end

  def create
    @campaign = @teacher.campaigns.new(safe_params)
    @campaign.setup_teacher_campaign(@teacher)

    if @campaign.save
      flash.now[:notice] = "Teacher Based Campaign was created successfully"
    else
      flash.now[:error] = "Error: #{@campaign.errors.full_messages.to_sentence}"
    end
  end


  private

  def set_teacher
    @teacher = Teacher.find(params[:teacher_id])
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
