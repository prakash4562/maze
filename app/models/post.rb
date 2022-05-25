
class Post < ApplicationRecord
  include Visible
  validates_presence_of :title
  validates_presence_of :content
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      headers = ['name', 'Content', 'Comments', 'Likes']
      CSV.generate_line headers
      csv << headers

      all.each do |post|
        csv << [name = "#{post['title']}", "#{post['content']}", post.comments.length, post.likes.length]
      end
    end
  end


end
