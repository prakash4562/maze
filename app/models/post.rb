
class Post < ApplicationRecord
  include Visible
  validates_presence_of :title
  validates_presence_of :content
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  # def self.to_csv
  #   CSV.generate(headers: true) do |csv|
  #     headers = ['Title', 'Content', 'Comments', 'Likes']
  #     CSV.generate_line headers
  #     csv << headers
  #
  #     all.each do |post|
  #       csv << [name = "#{post['title']}", "#{post['content']}", post.comments.length, post.likes.length]
  #     end
  #   end
  # end

    def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << column_names

      all.each do |post|
        csv << post.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Post.create! row.to_hash
    end
  end


end
