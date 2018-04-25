class User < ActiveRecord::Base
  has_many :posts
  has_secure_password
end

class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :user
end

class Comment < ActiveRecord::Base
  belongs_to :post
  validates :author, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
end

class Search
  attr_reader :input
  def initialize(input)
    @input = input
  end
end
