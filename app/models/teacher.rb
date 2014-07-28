class Teacher < ActiveRecord::Base

  # Because sometimes you just gotta call it like it is, mister.
  SUPERIORITY_PREFIXES = [
    "Ms",
    "Miss",
    "Mrs",
    "Mr",
    "Doctor",
    "Professor",
  ]

  belongs_to :school

  has_many :campaigns, -> { where(school_wide: false) }, as: :campaignable
  has_many :contributions, through: :campaigns

  sorty on: [:first_name, :last_name, :email, :prefix, :created_at, :updated_at],
    references: {school: "name"}

  validates :first_name, :last_name, :school, presence: true
  validates :last_name, uniqueness: { case_sensitive: false, scope: [:first_name, :school_id] }
  validates :email, presence: true,
    format: { with: Rails.application.config.email_regex },
    uniqueness: { case_sensitive: false }

  scope :ordered, -> { order("teachers.last_name ASC") }

  before_destroy :avert_destruction


  def self.with_campaigns
    Teacher.includes(:campaigns).where("campaigns.campaignable_id IS NOT NULL").references(:campaigns).uniq
  end

  def self.search(query)
    t = arel_table
    conditions = t[:last_name].matches("%#{query}%").or(t[:first_name].matches("#{query}%"))
    where(conditions)
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def prestigious_name
    [prefix, full_name].compact.join(" ")
  end

  def to_s
    full_name
  end

  def active_campaign_permalink
    active_campaign = campaigns.active.first
    if active_campaign.present?
      active_campaign.permalink
    end
  end


  def as_json(options)
    {
      id: id,
      prestigious_name: prestigious_name,
      email: email,
      school_id: school_id,
      permalink: active_campaign_permalink,
    }
  end

  def reassign(new_school_or_new_school_params)
    # Bail out if they don't pass us stuff
    return false if new_school_or_new_school_params.blank?

    if new_school_or_new_school_params.is_a?(School)
      # Do nothing, we're cool
      new_school = new_school_or_new_school_params
    elsif new_school_or_new_school_params.is_a?(Hash)
      new_school_id = new_school_or_new_school_params.try(:[], :new_school_id)
      new_school = School.find(new_school_id)
    else
      # Nothing found
      new_school = nil
    end

    if new_school.present?
      # Update all their campaigns
      campaigns.update_all({school_id: new_school.id, district_id: new_school.district.id, state_id: new_school.district.state.id})

      # Update my school_id
      update(school_id: new_school.id)

      # Return the new school
      new_school
    else
      # No school found
      nil
    end
  end


  private

  def avert_destruction
    if campaigns.present?
      self.errors.add(:base, "cannot remove a Teacher with associated Campaigns")
      false
    end
  end

end
