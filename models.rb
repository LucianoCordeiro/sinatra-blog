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
end
