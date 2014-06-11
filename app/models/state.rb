class State < ActiveRecord::Base

  sorty on: [:name, :abbr, :created_at, :updated_at]

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :abbr, presence: true, uniqueness: { case_sensitive: false }

  scope :ordered, -> { order("states.name ASC") }


  def self.search(query)
    t = arel_table
    conditions = t[:name].matches("#{query}%").or(t[:abbr].matches("#{query}"))
    where(conditions)
  end

end
