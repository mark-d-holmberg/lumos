class CampaignRequest < ActiveRecord::Base

  include Tokenable

  belongs_to :state

  validates :state, presence: true

  scope :ordered, -> { order("campaign_requests.created_at ASC") }

  before_create { |record| generate_token(:slug) if slug.nil? }



  def to_param
    slug
  end

end
