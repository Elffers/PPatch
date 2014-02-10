class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone, uniqueness: true
  validates :admin, inclusion: { in: [true, false] }


end
