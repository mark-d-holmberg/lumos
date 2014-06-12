class State < ActiveRecord::Base

  has_many :districts
  has_many :campaigns

  sorty on: [:name, :abbr, :created_at, :updated_at]

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :abbr, presence: true, uniqueness: { case_sensitive: false }

  scope :ordered, -> { order("states.name ASC") }

  before_destroy :avert_destruction


  def self.search(query)
    t = arel_table
    conditions = t[:name].matches("#{query}%").or(t[:abbr].matches("#{query}"))
    where(conditions)
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
