require 'csv'

class Post < ApplicationRecord
  include Visible
  validates_presence_of :title
  validates_presence_of :content
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  def self.to_csv
    attributes = %w{ id title content }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |post|
        csv << attributes.map { |attr| post.send(attr) }
      end
    end
  end


end
