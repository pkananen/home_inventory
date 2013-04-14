namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Example User",
					 email: "example@railstutorial.org",
					 password: "foobar",
					 password_confirmation: "foobar")
		admin.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "password"
			User.create!(name: name,
						 email: email,
						 password: password,
						 password_confirmation: password)
		end

		users = User.all(limit: 6)
		2.times do
			name = Faker::Lorem.sentence(2)
			home_type = "House"
			location = "Whatever, TX"
			users.each { |user| user.homes.create!(name: name, home_type: home_type, location: location)}
		end
	end
end
