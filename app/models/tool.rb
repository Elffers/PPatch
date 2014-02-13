class Tool < ActiveRecord::Base
  validates :name, presence: true
  validates :checkedin, inclusion: { in: [true, false] }
  belongs_to :user
end
