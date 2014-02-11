class Post < ActiveRecord::Base
  validates :title, :body, presence: true
  validates :title, uniqueness: true
end
