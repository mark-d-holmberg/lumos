class District < ActiveRecord::Base

  belongs_to :state

  has_many :schools
  has_many :campaigns

  sorty on: [:name, :created_at, :updated_at],
    references: {state: "name"}

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: [:state_id] }
  validates :state, presence: true

  scope :ordered, -> { order("districts.name ASC") }

  before_destroy :avert_destruction


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
    st = State.arel_table
    conditions = t[:name].matches("#{query}%")
    conditions = conditions.or(st[:name].matches("#{query}%"))
    includes(:state).where(conditions).references(:state)
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
