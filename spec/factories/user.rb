
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
    sequence :uid do |n|
      "#{n}"
    end
    avatar_url "some_url"
    token "some_token"
    secret "some_secret"
    preferences true
  end

end
