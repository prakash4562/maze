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
  has_many :likes, dependent: :destroy
  VALID_NUMBER_REGEX=/\A^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[789]\d{9}$\z/i
  validates :number, presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 10 ,maximum: 10 },
            format: { with: VALID_NUMBER_REGEX }


  after_create :assign_default_role

  def assign_default_role
    self.add_role(:newuser) if self.roles.blank?
  end

end
