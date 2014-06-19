class Campaign < ActiveRecord::Base

  include Tokenable
  include Dollars

  belongs_to :state
  belongs_to :district
  belongs_to :school
  belongs_to :campaignable, polymorphic: true

  has_many :contributions

  monetize :goal_amount_cents
  has_dollar_field :goal_amount

  sorty on: [:name, :school_wide, :goal_amount_cents],
    references: {state: "name", district: "name", school: "name"},
    polymorphic: {
      campaignable: {
        teacher: 'last_name',
        school: 'name',
      }
    }

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
    conditions = t[:name].matches("%#{query}%").or(t[:goal_amount_cents].gteq(query.gsub(/\D+/, '')))
    where(conditions)
  end

  def self.campaignable_types
    ['School', 'Teacher']
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
