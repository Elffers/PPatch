class Event < ActiveRecord::Base
  validates :name, presence: true
  validates :name, format: { with: /\w+/}
  validates :venue, presence: true
  validates :venue, format: { with: /\w+/}

  belongs_to :user

end
