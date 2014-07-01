class School < ActiveRecord::Base

  belongs_to :district

  has_one :state, through: :district

  has_many :teachers
  has_many :campaigns # This is an actual 1->1 non-polymorphic relation, for Teacher Based campaigns

  sorty on: [:name, :created_at, :updated_at],
    references: {district: "name"}

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: [:district_id] }
  validates :district, presence: true

  scope :ordered, -> { order("schools.name ASC") }

  before_destroy :avert_destruction


  def self.with_campaigns
    School.includes(:campaigns).where("campaigns.school_id IS NOT NULL").references(:campaigns).uniq
  end

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
    conditions = t[:name].matches("#{query}%")
    where(conditions)
  end

  def to_s
    name
  end

  def as_json(options)
    {id: id, name: name}
  end

  def school_wide_campaigns
    campaigns.where(school_wide: true, campaignable_type: 'School')
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
