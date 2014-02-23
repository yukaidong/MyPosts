FactoryGirl.define do
  factory :user do
		sequence(:name) {|n| "Person #{n}"}
		sequence(:email) {|n| "Person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
    	admin true
    end
  end

  factory :post do
    title "test"
  	content "Hello World"
  	user
  end
end