class Post < ActiveRecord::Base
  validates :title, :body, presence: true, allow_blank: false
  validates :title, uniqueness: true
  belongs_to :user
end
