class Product < ActiveRecord::Base

  include Dollars

  monetize :price_cents
  has_dollar_field :price

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :price, numericality: { greater_than: 0 }, presence: true

  scope :ordered, -> { order("products.name ASC") }

  # TODO: Don't let products associated with campaigns get deleted!

end
