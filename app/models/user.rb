class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :timeoutable, and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable,
         :confirmable,
         :lockable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy


  after_create :assign_default_role

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

end
