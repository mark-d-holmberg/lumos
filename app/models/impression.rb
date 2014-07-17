class Impression < ActiveRecord::Base

  include Tokenable

  validates :campaign, presence: true
  validates :email, presence: true,
    format: { with: Rails.application.config.email_regex }

  belongs_to :campaign

  scope :ordered, -> { order("impressions.created_at ASC") }
  scope :with_date, -> (date) { where("impressions.created_at >= ? AND impressions.created_at < ?", date.beginning_of_day, date.end_of_day) }

  before_create { |record| generate_token(:token) if token.nil? }

  # Set the token, etc

end
