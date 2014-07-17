class Contribution < ActiveRecord::Base

  include Dollars

  belongs_to :contributor
  belongs_to :campaign

  sorty on: [:pledge_id, :pledged_at, :amount_cents, :imported_at],
    references: {contributor: "name", campaign: "name"}

  validates :pledge_id, presence: true, numericality: { only_integer: true }, uniqueness: true
  validates :pledged_at, presence: true
  validates :campaign, :contributor, presence: true
  validates :amount, numericality: { greater_than: 0 }, presence: true
  validates :impression_token, uniqueness: { case_sensitive: false }

  monetize :amount_cents
  has_dollar_field :amount

  scope :ordered, -> { order("contributions.pledge_id ASC") }


  def self.search(query)
    t = arel_table
    cot = Contributor.arel_table
    ct = Campaign.arel_table
    conditions = t[:pledge_id].matches("#{query}%").or(t[:amount_cents].matches(query.gsub(/\D+/, '')))
    conditions = conditions.or(cot[:name].matches("#{query}%").or(cot[:email].matches("#{query}%")))
    conditions = conditions.or(ct[:name].matches("%#{query}%"))
    includes([:contributor, :campaign]).where(conditions).references([:contributor, :campaign])
  end

end
