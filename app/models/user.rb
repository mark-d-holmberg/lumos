class User < ActiveRecord::Base

  devise :database_authenticatable, :timeoutable, :recoverable, :rememberable, :trackable, :validatable

end
