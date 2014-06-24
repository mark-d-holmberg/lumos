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

  sorty on: [:first_name, :last_name, :email, :created_at, :updated_at],
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
    st = School.arel_table
    conditions = t[:last_name].matches("%#{query}%").or(t[:first_name].matches("#{query}%"))
    conditions = conditions.or(st[:name].matches("#{query}%"))
    includes(:school).where(conditions).references(:school)
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


  private

  def avert_destruction
    if campaigns.present?
      self.errors.add(:base, "cannot remove a Teacher with associated Campaigns")
      false
    end
  end

end
