class School < ActiveRecord::Base

  belongs_to :district

  has_one :state, through: :district

  has_many :teachers
  has_many :campaigns, -> { where(school_wide: false) }
  has_many :school_wide_campaigns, -> { where(school_wide: true) }, as: :campaignable, class_name: 'Campaign'

  sorty on: [:name, :created_at, :updated_at],
    references: {district: "name"}

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: [:district_id] }
  validates :district, presence: true

  scope :ordered, -> { order("schools.name ASC") }

  before_destroy :avert_destruction


  def self.without_teachers
    existing_ids = Teacher.all.pluck(:school_id)
    if existing_ids.empty?
      all
    else
      where("schools.id NOT IN (?)", existing_ids)
    end
  end

  def self.search(query)
    t = arel_table
    dt = District.arel_table
    st = State.arel_table
    conditions = t[:name].matches("#{query}%")
    conditions = conditions.or(dt[:name].matches("#{query}%"))
    conditions = conditions.or(st[:name].matches("#{query}%"))
    includes([:state, :district]).where(conditions).references([:state, :district])
  end

  def to_s
    name
  end

  def as_json(options)
    {id: id, name: name}
  end


  private

  def avert_destruction
    if teachers.present?
      self.errors.add(:base, "cannot remove a School with associated Teachers")
      false
    elsif campaigns.present?
      self.errors.add(:base, "cannot remove a School with associated Campaigns")
      false
    elsif school_wide_campaigns.present?
      self.errors.add(:base, "cannot remove a School with associated School Wide Campaigns")
      false
    end
  end

end
