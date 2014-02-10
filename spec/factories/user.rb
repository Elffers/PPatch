
FactoryGirl.define do
  factory :user do
    sequence :name do |n|
      "User #{n}"
    end
    sequence :email do |n|
      "#{n}@example.com"
    end
    number = 123456789 # may need to tweak based on uniqueness/format validations
    sequence :phone do |n|
      (number + n).to_s 
    end
    admin false
  end

end

 # User.create!(
 #      uid:        auth_hash[:uid],
 #      name:       auth_hash[:provider],
 #      avatar_url: auth_hash[:info][:image] || auth_hash[:info][:avatar],
 #      username:   auth_hash[:info][:nickname],
 #      secret:     auth_hash[:credentials][:secret], 
 #      token:      auth_hash[:credentials][:token]
 #    )