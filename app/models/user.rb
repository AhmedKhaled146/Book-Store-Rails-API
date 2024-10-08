class User < ApplicationRecord

  before_create :set_default_role
  enum role: { regular: "regular", admin: "admin" }

  has_many :bookings

  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  private

  def set_default_role
    self.role ||= :regular
  end
end
