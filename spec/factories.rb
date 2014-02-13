FactoryGirl.define do
  factory :user do
    name     "Bart Chan"
    email    "chenhx@test.com"
    password "foobar"
    password_confirmation "foobar"
  end
end