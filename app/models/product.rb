class Product < ActiveRecord::Base

  include Dollars

  has_many :campaigns
  has_many :campaign_requests

  monetize :price_cents
  has_dollar_field :price

  sorty on: [:name, :price_cents, :created_at, :updated_at]

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :price, numericality: { greater_than: 0 }, presence: true

  scope :ordered, -> { order("products.name ASC") }

  before_destroy :avert_destruction


  def self.search(query)
    t = arel_table
    conditions = t[:name].matches("%#{query}%")
    where(conditions)
  end

  def pretty_name
    [name, price.to_s].join(" $")
  end


  private

  def avert_destruction
    if campaigns.present?
      self.errors.add(:base, "cannot remove a Product with associated Campaigns")
      false
    end
  end

end
