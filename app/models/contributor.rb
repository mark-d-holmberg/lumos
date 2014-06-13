class Contributor < ActiveRecord::Base

  has_many :contributions

  sorty on: [:name, :email, :created_at, :updated_at]

  validates :name, presence: true, uniqueness: { scope: [:email] }
  validates :email, presence: true,
    format: { with: Rails.application.config.email_regex },
    uniqueness: { case_sensitive: false }

  scope :ordered, -> { order("contributors.name ASC") }

  before_destroy :avert_destruction


  def self.search(query)
    t = arel_table
    conditions = t[:name].matches("#{query}%").or(t[:email].matches("%#{query}%"))
    where(conditions)
  end


  private

  def avert_destruction
    if contributions.present?
      self.errors.add(:base, "cannot remove a Contributor with associated Contributions")
      false
    end
  end

end
