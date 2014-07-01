class District < ActiveRecord::Base

  belongs_to :state

  has_many :schools
  has_many :campaigns

  sorty on: [:name, :created_at, :updated_at]

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: [:state_id] }
  validates :state, presence: true

  scope :ordered, -> { order("districts.name ASC") }
  scope :with_state, -> (state_abbr) { includes(:state).where("states.abbr = ?", state_abbr).references(:state) }

  before_destroy :avert_destruction


  def self.with_schools
    District.includes(:schools).where("schools.district_id IS NOT NULL").references(:schools).uniq
  end

  def self.without_schools
    existing_ids = School.all.pluck(:district_id)
    if existing_ids.empty?
      all
    else
      where("districts.id NOT IN (?)", existing_ids)
    end
  end

  def self.search(query)
    t = arel_table
    conditions = t[:name].matches("#{query}%")
    where(conditions)
  end

  def as_json(options)
    {id: id, name: name}
  end


  private

  def avert_destruction
    if schools.present?
      self.errors.add(:base, "cannot remove a District with associated Schools")
      false
    elsif campaigns.present?
      self.errors.add(:base, "cannot remove a District with associated Campaigns")
      false
    end
  end

end
