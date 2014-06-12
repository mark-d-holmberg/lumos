class Teacher < ActiveRecord::Base

  belongs_to :school

  sorty on: [:first_name, :last_name, :created_at, :updated_at],
    references: {school: "name"}

  validates :first_name, :last_name, :school, presence: true
  validates :last_name, uniqueness: { case_sensitive: false, scope: [:first_name, :school_id] }

  scope :ordered, -> { order("teachers.last_name ASC") }


  def self.search(query)
    t = arel_table
    st = School.arel_table
    conditions = t[:last_name].matches("%#{query}%").or(t[:first_name].matches("#{query}%"))
    conditions = conditions.or(st[:name].matches("#{query}%"))
    includes(:school).where(conditions).references(:school)
  end

  def full_name
    [first_name, last_name].join(" ")
  end

end
