class Campaign < ActiveRecord::Base

  include Tokenable
  include Dollars

  belongs_to :state
  belongs_to :district
  belongs_to :school
  belongs_to :campaignable, polymorphic: true
  belongs_to :teacher, -> { where("campaigns.campaignable_type = 'Teacher'") }, foreign_key: 'campaignable_id'

  has_many :contributions

  monetize :goal_amount_cents
  has_dollar_field :goal_amount

  sorty on: [:name, :school_wide, :goal_amount_cents],
    references: {state: "name", district: "name", school: "name", teacher: 'last_name'}

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :state, :district, :school, presence: true
  validates :campaignable, presence: true
  validates :slug, uniqueness: { case_sensitive: false }
  validates :school_wide, inclusion: { in: [true, false] }
  validates :district_id, inclusion: { in: Proc.new { |k| k.state.district_ids } }, if: Proc.new { |k| k.state.present? }
  validates :school_id, inclusion: { in: Proc.new { |k| k.district.school_ids } }, if: Proc.new { |k| k.district.present? }
  validates :campaignable_id, inclusion: { in: Proc.new { |k| k.school.teacher_ids } }, if: Proc.new { |k| k.campaignable.present? && !k.school_wide? }
  validates :campaignable_type, inclusion: { in: Proc.new { Campaign.campaignable_types } }, presence: true
  validates :campaignable_id, uniqueness: { scope: [:school_id] }, if: Proc.new { |k| k.active? && k.school_wide? }
  validates :goal_amount, numericality: { greater_than: 0 }, presence: true
  validates :goal_amount_cents, numericality: { less_than_or_equal_to: 90000 }, if: Proc.new { |k| !k.school_wide? }

  scope :ordered, -> { order("campaigns.name ASC") }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where.not(active: true) }
  scope :teacher_based, -> { where(school_wide: false) }
  scope :school_based, -> { where(school_wide: true) }

  before_create { |record| generate_token(:slug) if slug.nil? }
  before_destroy :avert_destruction


  def self.search(query)
    t = arel_table
    sct = School.arel_table
    st = State.arel_table

    # Only do a goal amount if we have an number
    goal_amount_query = query.gsub(/\D+/, '')
    conditions = t[:name].matches("%#{query}%")
    if goal_amount_query.present?
      conditions = conditions.or(t[:goal_amount_cents].gteq(goal_amount_query))
    end

    # Find based on other tables
    conditions = conditions.or(sct[:name].matches("#{query}%"))
    conditions = conditions.or(st[:name].matches("#{query}%"))
    includes([:school, :state]).where(conditions).references([:school, :state])
  end

  def self.campaignable_types
    ['School', 'Teacher']
  end

  def as_json(options)
    super.slice("slug", "name", "campaignable_id", "campaignable_type", "school_wide", "goal_amount_cents")
  end

  def to_param
    slug
  end

  def contributable?
    if active?
      # Make sure we're not archived
      if school_wide?
        # School Based
        true # We have an infinite amount
      else
        # Teacher Based
        contributions_amount_cents = contributions.pluck(:amount_cents).sum
        (contributions_amount_cents < goal_amount_cents) ? true : false
      end
    else
      # Inactive campaigns can never have more contributions placed for them
      false
    end
  end


  private

  def avert_destruction
    if active?
      self.errors.add(:base, "cannot remove an active Campaign")
      false
    elsif contributions.present?
      self.errors.add(:base, "cannot remove a Campaign with associated Contributions")
      false
    end
  end

end
