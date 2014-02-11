# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    time "2014-02-10 11:08:48"
    venue "MyString"
    description "MyText"
    name "MyString"
    user_id 1
  end
end
