class State < ActiveRecord::Base

  has_many :districts
  has_many :campaigns

  sorty on: [:name, :abbr, :created_at, :updated_at]

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :abbr, presence: true, uniqueness: { case_sensitive: false }

  scope :ordered, -> { order("states.name ASC") }

  before_destroy :avert_destruction


  def self.with_districts
    State.includes(:districts).where("districts.state_id IS NOT NULL").references(:districts).uniq
  end

  def self.without_districts
    existing_ids = District.all.pluck(:state_id)
    if existing_ids.empty?
      all
    else
      where("states.id NOT IN (?)", existing_ids)
    end
  end

  def self.search(query)
    t = arel_table
    conditions = t[:name].matches("#{query}%").or(t[:abbr].matches("#{query}"))
    where(conditions)
  end

  def to_param
    abbr
  end

  def ordered_districts
    districts.ordered
  end


  private

  def avert_destruction
    if districts.present?
      self.errors.add(:base, "cannot remove a State with associated Districts")
      false
    elsif campaigns.present?
      self.errors.add(:base, "cannot remove a State with associated Campaigns")
      false
    end
  end

end
