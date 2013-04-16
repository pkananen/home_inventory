require 'spec_helper'
describe "Authentication" do
	subject {page}

	describe "signin page" do
		before {visit signin_path}

		it {should have_selector('h1', text: 'Sign in')}
		it {should have_selector('title', text: 'Sign in')}
	end

	describe "signin" do
		before {visit signin_path}

		describe "with invalid information" do
			before {click_button "Sign in"}

			it {should have_selector('title', text: 'Sign in')}
			it {should have_selector('div.alert.alert-error', text: 'Invalid')}

			describe "after visiting another page" do
				before {click_link "Home"}
				it {should_not have_selector('div.alert.alert-error')}
			end			
		end

		describe "with valid information" do
			let(:user) {FactoryGirl.create(:user)}
			before {sign_in user}

			it {should have_selector('title', text: user.name)}

			it {should have_link('Users', href: users_path)}
			it {should have_link('Profile', href: user_path(user))}
			it {should have_link('Settings', href: edit_user_path(user))}
			it {should have_link('Sign out', href: signout_path)}
			
			it {should_not have_link('Sign in', href: signin_path)}

			describe "followed by signout" do
				before {click_link "Sign out"}
				it {should have_link('Sign in')}
			end
		end
	end

	describe "authorization" do
		describe "for signed-in users" do
			let(:user) {FactoryGirl.create(:user)}
			before {sign_in user}

			describe "in the Users controller" do
				describe "visiting the new page" do
					before {visit new_user_path}
					it {should_not have_selector('title', text: 'Sign up')}
				end

				describe "submitting to the create action" do
					before {post users_path}
					specify {response.should redirect_to(root_path)}
				end

				# Redirect to user's own profile page if attempting to access
				# someone else's profile page.
				describe "visiting another user's page" do
					let(:other_user) {FactoryGirl.create(:user, email: "someone-else@exmaple.com")}
					before {visit user_path(other_user)}

					it {should_not have_selector('title', text: other_user.name)}
				end
			end

			describe "in the Homes controller" do
				describe "visiting another user's home's page" do
					let(:other_user) {FactoryGirl.create(:user, email: "someone-else@example.com")}
					let(:home) {FactoryGirl.create(:home, user: other_user)}

					before {visit home_path(home)}

					it {should_not have_selector('title', text: home.name)}
				end
			end
		end

		describe "for non-signed-in users" do
			let(:user) {FactoryGirl.create(:user)}

			it {should_not have_link('Users', href: users_path)}
			it {should_not have_link('Profile', href: user_path(user))}
			it {should_not have_link('Settings', href: edit_user_path(user))}
			it {should_not have_link('Sign out', href: signout_path)}

			describe "in the Users controller" do
				describe "visiting the edit page" do
					before {visit edit_user_path(user)}
					it {should have_selector('title', text: 'Sign in')}
				end

				describe "submitting to the update action" do
					before {put user_path(user)}
					specify {response.should redirect_to(signin_path)}
				end

				describe "visiting the user index" do
					before {visit users_path}
					it {should have_selector('title', text: 'Sign in')}
				end

				# Redirect to sign in page if attempting to visit a user's page
				# without being signed in.
				describe "attempting to visit a user page" do
					before {visit user_path(user)}
					it {should have_selector('title', text: 'Sign in')}
				end
			end

			describe "in the Homes controller" do
				describe "attempting to visit a home page" do
					let(:home) {FactoryGirl.create(:home, user: user)}
					before {visit home_path(home)}

					it {should have_selector('title', text: 'Sign in')}
				end
			end

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					sign_in user
				end

				describe "after signing in" do
					it "should render the desired protected page" do
						page.should have_selector('title', text: 'Edit user')
					end

					describe "when signing in again" do
						before do
							delete signout_path
							sign_in user
						end

						it "should render the default (profile) page" do
							page.should have_selector('title', text: user.name)
						end
					end
				end
			end

			describe "as non-admin user" do
				let(:user) {FactoryGirl.create(:user)}
				let(:non_admin) {FactoryGirl.create(:user)}

				before {sign_in non_admin}

				describe "submitting a DELETE request to the User#destroy action" do
					before {delete user_path(user)}
					specify {response.should redirect_to(root_path)}
				end
			end
		end

		describe "as wrong user" do
			let(:user) {FactoryGirl.create(:user)}
			let(:wrong_user) {FactoryGirl.create(:user, email: "wrong@example.com")}
			before {sign_in user}

			describe "visiting Users#edit page" do
				before {visit edit_user_path(wrong_user)}
				it {should_not have_selector('title', text: full_title('Edit user'))}
			end

			describe "submitting a PUT request to the Users#update action" do
				before {put user_path(wrong_user)}
				specify {response.should redirect_to(root_path)}
			end
		end
	end
end
