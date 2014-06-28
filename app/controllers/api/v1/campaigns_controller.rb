class Api::V1::CampaignsController < ApiController
  before_action :load_school

  respond_to :json

  def index
    @campaigns = @school.campaigns.active.ordered

    # Make sure we only return this one
    campaignable_type = params.try(:[], :campaignable_type)
    if campaignable_type.present?
      if campaignable_type == 'School'
        @campaigns = @campaigns.school_based.active.first
      else
        @campaigns = @school.teachers.ordered
      end
    end

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
