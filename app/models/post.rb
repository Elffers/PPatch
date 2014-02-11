class Post < ActiveRecord::Base
  validates :title, :body, presence: true
  validates :title, uniqueness: true
  belongs_to :user
end
