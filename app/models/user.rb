class User < ActiveRecord::Base
  validates :uid, presence: true
  validates :name, uniqueness: true
  validates :email, uniqueness: true
  validates :phone, uniqueness: true
  validates :admin, inclusion: { in: [true, false] }



  # def self.create_from_omniauth(auth_hash)
  #   User.create!(
  #     uid:        auth_hash[:uid],
  #     avatar_url: auth_hash[:info][:image] || auth_hash[:info][:avatar],
  #     name:       auth_hash[:info][:nickname],
  #     secret:     auth_hash[:credentials][:secret], 
  #     token:      auth_hash[:credentials][:token]
  #   )
  #   rescue ActiveRecord::RecordInvalid
  #     nil
  # end

end
