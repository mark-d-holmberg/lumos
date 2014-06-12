class Campaign < ActiveRecord::Base

  belongs_to :state
  belongs_to :district
  belongs_to :school
  belongs_to :teacher

  sorty on: [:name, :created_at, :updated_at],
    references: {state: "name", district: "name", school: "name", teacher: "last_name"}

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :state, :district, :school, :teacher, presence: true

  scope :ordered, -> { order("campaigns.name ASC") }

  before_destroy :avert_destruction


  def self.search(query)
    t = arel_table
    conditions = t[:name].matches("%#{query}%")
    where(conditions)
  end


  private

  def avert_destruction
    false if active?
  end

end
