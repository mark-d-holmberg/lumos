class District < ActiveRecord::Base

  belongs_to :state

  sorty on: [:name, :created_at, :updated_at],
    references: {state: "name"}

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: [:state_id] }
  validates :state, presence: true

  scope :ordered, -> { order("districts.name ASC") }


  def self.search(query)
    t = arel_table
    st = State.arel_table
    conditions = t[:name].matches("#{query}%")
    conditions = conditions.or(st[:name].matches("#{query}%"))
    includes(:state).where(conditions).references(:state)
  end

end
