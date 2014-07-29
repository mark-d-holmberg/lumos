class CampaignRequest < ActiveRecord::Base

  include Tokenable

  belongs_to :state

  validates :state, presence: true

  scope :ordered, -> { order("campaign_requests.created_at ASC") }

  before_create { |record| generate_token(:slug) if slug.nil? }


  def to_param
    slug
  end

  def convert(params={})
    # Find our potential new state
    state_id = params.try(:[], "state_id")
    if params.try(:[], "associations").present?
      override_params = params["associations"]
      district_id     = override_params.try(:[], "district_id")
      school_id       = override_params.try(:[], "school_id")
      teacher_id      = override_params.try(:[], "teacher_id")
    end

    # Get the user-submitted parameters
    my_district_name   = params.try(:[], "district_name")
    my_school_name     = params.try(:[], "school_name")

    # Bail out!
    teacher_full_name  = params.try(:[], "teacher_name")
    return false if teacher_full_name.blank?

    teacher_first_name = teacher_full_name.split(" ").first
    teacher_last_name  = teacher_full_name.split(" ").last
    my_email           = params.try(:[], "email")
    my_school_wide     = (params.try(:[], "school_wide") == 'true') ? true : false

    # Find the stuff, or create new stuff
    my_state = state_id.present? ? State.find(state_id) : state
    district = district_id.present? ? my_state.districts.find(district_id) : my_state.districts.find_or_create_by(name: my_district_name)
    school = school_id.present? ? district.schools.find(school_id) : district.schools.find_or_create_by(name: my_school_name)
    teacher = teacher_id.present? ? school.teachers.find(teacher_id) : school.teachers.find_or_create_by(first_name: teacher_first_name, last_name: teacher_last_name, email: my_email)

    if my_state && district && school && teacher
      # We did it!
      true
    else
      # You can never fail if you constantly redefine success
      false
    end
  end

end
