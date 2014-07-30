class CampaignRequest < ActiveRecord::Base

  # TODO: approved_at column
  include Tokenable

  belongs_to :state
  belongs_to :product
  belongs_to :campaign

  validates :state, :product, presence: true
  validates :physical_address, :physical_city, :physical_state, :physical_postal_code, presence: true

  scope :ordered, -> { order("campaign_requests.created_at ASC") }
  scope :not_approved, -> { where(approved_at: nil) }

  before_create { |record| generate_token(:slug) if slug.nil? }


  def to_param
    slug
  end

  def convert(params={})
    # {"campaign_name"=>"Help Jessica Ross Get to Rexburg!", "email"=>"whatevadads@example.com", "physical_address"=>"1234 USA Drive", "physical_address_ext"=>"", "physical_city"=>"Saint George", "physical_postal_code"=>"84770", "physical_state"=>"Utah", "product_id"=>"1", "school_wide"=>"true", "state_id"=>"44", "teacher_first_name"=>"Jessica", "teacher_last_name"=>"Ross", "associations"=>{"district_id"=>"1940", "school_id"=>"81376", "teacher_id"=>""}}

    # Don't convert already converted stuff
    return false if campaign.present?

    # Find out our normal information
    my_state_id             = params.try(:[], "state_id")
    my_product_id           = params.try(:[], "product_id")
    my_physical_address     = params.try(:[], "physical_address").presence || physical_address
    my_physical_address_ext = params.try(:[], "physical_address_ext").presence || physical_address_ext
    my_physical_city        = params.try(:[], "physical_city").presence || physical_city
    my_physical_state       = params.try(:[], "physical_state").presence || physical_state
    my_physical_postal_code = params.try(:[], "physical_postal_code").presence || physical_postal_code

    if params.try(:[], "associations").present?
      override_params = params["associations"]
      district_id     = override_params.try(:[], "district_id")
      school_id       = override_params.try(:[], "school_id")
      teacher_id      = override_params.try(:[], "teacher_id")
    end

    # Get the user-submitted parameters
    my_district_name   = params.try(:[], "district_name")
    my_school_name     = params.try(:[], "school_name")
    teacher_first_name = params.try(:[], "teacher_first_name")
    teacher_last_name  = params.try(:[], "teacher_last_name")
    my_email           = params.try(:[], "email")
    my_school_wide     = (params.try(:[], "school_wide") == 'true') ? true : false
    my_campaign_name   = params.try(:[], "campaign_name").presence || campaign_name

    # Require the campaign_name
    return false if my_campaign_name.blank?

    # Check for the address fields
    return false if (my_physical_address.blank?)
    return false if (my_physical_city.blank?)
    return false if (my_physical_state.blank?)
    return false if (my_physical_postal_code.blank?)

    # State
    if my_state_id.present?
      my_state = State.find(my_state_id)
    else
      my_state = state
    end

    # Bail out if no State
    return false if my_state.nil?

    # Product
    if my_product_id.present?
      my_product = Product.find(my_product_id)
    else
      my_product = product
    end

    # Bail out if no Product
    return false if my_product.nil?

    # District
    if district_id.present?
      district = my_state.districts.find(district_id)
    else
      # Require a district_name
      return false if my_district_name.blank?
      district = my_state.districts.find_or_create_by!(name: my_district_name)
    end

    # Bail out if no District
    return false if district.nil?

    # School
    if school_id.present?
      school = district.schools.find(school_id)
    else
      # Require a school_name
      return false if my_school_name.blank?
      school = district.schools.find_or_create_by!(name: my_school_name)
    end

    # Bail out if no School
    return false if school.nil?

    # Teacher
    if teacher_id.present?
      teacher = school.teachers.find(teacher_id)
    else
      return false if (teacher_first_name.blank? || teacher_last_name.blank?)
      teacher = school.teachers.find_or_create_by(first_name: teacher_first_name, last_name: teacher_last_name, email: my_email)
    end

    # Bail out if no Teacher
    return false if teacher.nil?

    if my_state.present? && district.present? && school.present? && teacher.present? && my_product.present?
      if my_school_wide
        # School Based Campaigns
        campaign = Campaign.create!({
          state: my_state,
          district: district,
          name: my_campaign_name,
          school: school,
          campaignable_id: school.id,
          campaignable_type: 'School',
          goal_amount_cents: 1,
          product_id: my_product.id,
          active: true,
          school_wide: true,
          physical_address: my_physical_address,
          physical_address_ext: my_physical_address_ext,
          physical_city: my_physical_city,
          physical_state: my_physical_state,
          physical_postal_code: my_physical_postal_code,
        })
      else
        # Teacher Based Campaigns
        campaign = Campaign.create!({
          state: my_state,
          district: district,
          school: school,
          name: my_campaign_name,
          campaignable_id: teacher.id,
          campaignable_type: 'Teacher',
          active: true,
          school_wide: false,
          goal_amount_cents: 1,
          product_id: my_product.id,
          physical_address: my_physical_address,
          physical_address_ext: my_physical_address_ext,
          physical_city: my_physical_city,
          physical_state: my_physical_state,
          physical_postal_code: my_physical_postal_code,
        })
      end

      # TODO: Email this fool

      # Update the approved_at date and the campaign association
      update({
        approved_at: Time.zone.now,
        campaign_id: campaign.id,
        campaign_name: my_campaign_name,
        district_name: district.name,
        email: my_email,
        physical_address: my_physical_address,
        physical_address_ext: my_physical_address_ext,
        physical_city: my_physical_city,
        physical_postal_code: my_physical_postal_code,
        physical_state: my_physical_state,
        product_id: my_product.id,
        school_name: school.name,
        school_wide: school_wide,
        state_id: my_state.id,
        teacher_first_name: teacher.first_name,
        teacher_last_name: teacher.last_name,
      })

      # We did it!
      campaign.persisted?
    else
      raise [my_state, district, school, teacher, my_product].inspect
      # You can never fail if you constantly redefine success
      false
    end
  end

end
