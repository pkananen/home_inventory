require 'spec_helper'

describe "HomePages" do
	subject {page}

	describe "view home page" do
		let(:user) {FactoryGirl.create(:user)}
		let(:home) {FactoryGirl.create(:home, user: user)}

		before do
			sign_in user
			visit home_path(home)
		end

		it {should have_selector('title', text: home.name)}
		it {should have_selector('h1', text: home.name)}

		it {should have_link('Add item', href: '#')}
		it {should have_link('Edit home', href: edit_home_path(home))}

		# items list tests
	end

	describe "create a home" do
		let(:user) {FactoryGirl.create(:user)}
		let(:submit) {"Create home"}
		let(:title) {"Create a home"}

		before do
			sign_in user
			visit new_home_path
		end

		it {should have_selector('title', text: title)}

		describe "with invalid information" do
			it "should not create a home" do
				expect {click_button submit}.not_to change(Home, :count)
			end

			it {should have_selector('title', text: title)}
		end

		describe "with valid information" do
			before do
				fill_in "Name", with: "Example Home"
				fill_in "Location", with: "Brooklyn, NY"
				fill_in "Type", with: "Apartment"
			end

			it "should create a home" do
				expect {click_button submit}.to change(Home, :count).by(1)
			end

			describe "after saving the home" do
				before {click_button submit}
				let(:home) {Home.find_by_name("Example Home")}

				it {should have_selector('title', text: home.name)}
				it {should have_selector('div.alert.alert-success', text: "Home successfully created!")}
			end
		end
	end

	describe "edit home" do
		let(:user) {FactoryGirl.create(:user)}
		let(:home) {FactoryGirl.create(:home, user: user)}

		before do
			sign_in user
			visit edit_home_path(home)
		end

		describe "page" do
			it {should have_selector('h1', text: "Update this home")}
			it {should have_selector('title', text: "Edit home")}
			it {should have_link('delete', href: home_path(home))}
		end

		describe "with invalid information" do
			before do
				fill_in "Name", with: " "
				click_button "Save changes"
			end

			it {should have_content('error')}
		end

		describe "with valid information" do
			let(:new_name) {"New House"}
			let(:new_location) {"Transylvania"}

			before do
				fill_in "Name", with: new_name
				fill_in "Location", with: new_location
				fill_in "Type", with: home.home_type
				click_button "Save changes"
			end

			it {should have_selector('title', text: new_name)}
			it {should have_selector('div.alert.alert-success')}
			specify {home.reload.name.should == new_name}
			specify {home.reload.location.should == new_location}

			describe "delete home" do
				before {visit edit_home_path(home)}

				it {expect {click_link('delete')}.to change(Home, :count).by(-1)}

				# Should go to user profile after deleting a home
				#it {should have_selector('title', text: user.name)}
			end
		end
	end
end
