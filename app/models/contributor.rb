class Contributor < ActiveRecord::Base

  sorty on: [:name, :email, :created_at, :updated_at]

  validates :name, presence: true, uniqueness: { scope: [:email] }
  validates :email, presence: true,
    format: { with: Rails.application.config.email_regex },
    uniqueness: { case_sensitive: false }

  scope :ordered, -> { order("contributors.name ASC") }

  # TODO: contributions

  # TODO: Don't let them destroy contributors with contributions


  def self.search(query)
    t = arel_table
    conditions = t[:name].matches("#{query}%").or(t[:email].matches("%#{query}%"))
    where(conditions)
  end

end
