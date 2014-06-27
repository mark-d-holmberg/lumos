class Impression < ActiveRecord::Base

  include Tokenable

  validates :campaign, presence: true
  validates :email, presence: true,
    format: { with: Rails.application.config.email_regex }

  belongs_to :campaign

  scope :ordered, -> { order("impressions.created_at ASC") }

  before_create { |record| generate_token(:token) if token.nil? }

  # Set the token, etc

end
