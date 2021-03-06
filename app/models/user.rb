class User < ApplicationRecord
  # file = @file
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
  VALID_NUMBER_REGEX = /\A^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[789]\d{9}$\z/i
  validates :number, presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 10, maximum: 10 },
            format: { with: VALID_NUMBER_REGEX }

  after_create :assign_default_role

  def assign_default_role
    self.add_role(:newuser) if self.roles.blank?
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      headers = ['Name', 'Posts', 'Comments', 'Likes']
      CSV.generate_line headers
      csv << headers

      all.each do |user|
        csv << [name = "#{user['name']} #{user['lname']}", user.posts.length, user.comments.length, user.likes.length]
      end
    end
  end

  #   def self.to_csv
  #   CSV.generate(headers: true) do |csv|
  #     headers = ['email', 'name', 'lname', 'number', 'password', 'password_confirmation']
  #     CSV.generate_line headers
  #     csv << headers
  #
  #     all.each do |user|
  #       csv << ["#{user['email']}", "#{user['name']}", "#{user['lname']}", "#{user['number']}", "#{user['password']}", "#{user['password_confirmation']}"]
  #     end
  #   end
  # end

  def self.to_csv_limited
    CSV.generate(headers: true) do |csv|
      headers = ['Name', 'Posts', 'Comments', 'Likes']
      CSV.generate_line headers
      csv << headers

      all.each do |user|
        if user.posts.length >= 10
          csv << [name = "#{user['name']} #{user['lname']}", user.posts.length, user.comments.length, user.likes.length]
        end
      end
    end
  end

  # def self.import(file)
  #   CSV.foreach(file.path, headers: true) do |row|
  #     User.create! row.to_hash
  #   end
  # end

  def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
  when '.csv' then Roo::Spreadsheet.open(file)
  # when '.xls' then Roo::Excel.new("file")
  when '.xlsx' then Roo::Spreadsheet.open(file)
  else raise "Unknown file type: #{file.original_filename}"
  end
  end

    def self.import(file)

      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        user = find_by_id(row["id"]) || new
        user.attributes = row
        user.save!
      end
    end

  # def self.import(file)
  #   CSV.foreach(file.path, headers: true) do |row|
  #     User.create! row.to_hash
  #   end
  # end

end


