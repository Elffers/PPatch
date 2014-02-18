# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rsvp do
    user
    event
  end
end
