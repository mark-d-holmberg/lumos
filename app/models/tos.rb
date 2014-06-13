class Tos < ActiveRecord::Base

  validates :content, presence: true
  validate :force_singleton


  private

  def force_singleton
    # This is wrong and I know it
    if new_record?
      self.errors.add(:base, "cannot have multiple Terms and Conditions") if Tos.all.any?
      false
    else
      # Existing Record
    end
  end

end
