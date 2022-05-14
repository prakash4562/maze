class Post < ApplicationRecord
  include Visible
  validates_presence_of :title
  validates_presence_of :content
  belongs_to :user
  has_many :comments, dependent: :destroy
end
