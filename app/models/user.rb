class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w(admin operator customer wholesaler)

  validates :first_name, :last_name, presence: true, length: { minimum: 2 }
  validates :role, presence: true, inclusion: ROLES

  def admin?
    %w(admin operator).include?(role)
  end
end
