class Tool < ActiveRecord::Base
  validates :name, presence: true
  validates :checkecin, inclusion: { in: [true, false] }
end
