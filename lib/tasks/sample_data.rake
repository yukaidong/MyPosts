namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		User.create!(name:"Example User", email:"example@railstutorial.org",
								password: "foobar", password_confirmation:"foobar",
								admin: true)
		49.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "password"
			User.create!(name: name,email: email,password: password, password_confirmation: password)
		end

		users = User.all(limit: 2)
		50.times do
			title = Faker::Lorem.sentence(1)
			content = Faker::Lorem.sentence(5)
			users.each{|user| user.posts.create!(title: title, content: content)}
		end
	end
end