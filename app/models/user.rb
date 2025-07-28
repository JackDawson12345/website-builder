class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :website, dependent: :destroy

  def admin?
    admin
  end

  def customer?
    !admin
  end
end