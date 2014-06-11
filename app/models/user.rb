class User < ActiveRecord::Base

  devise :database_authenticatable, :timeoutable, :recoverable, :rememberable, :trackable, :validatable

  sorty on: [:email, :sign_in_count, :created_at, :updated_at]

  scope :ordered, -> { order("users.email ASC") }


  def self.search(query)
    t = arel_table
    conditions = t[:email].matches("#{query}%")
    where(conditions)
  end

end
