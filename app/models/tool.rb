class Tool < ActiveRecord::Base
  validates :name, presence: true
  validates :checkedin, inclusion: { in: [true, false] }
end
