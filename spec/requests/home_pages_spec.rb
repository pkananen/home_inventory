require 'spec_helper'

describe "HomePages" do
	subject {page}

	describe "view home page" do
		let(:user) {FactoryGirl.create(:user)}
		let(:home) {FactoryGirl.create(:home, user: user)}

		before {visit home_path(home)}

		it {should have_selector('title', text: home.name)}
		it {should have_selector('h1', text: home.name)}

		it {should have_link('Add Item', href: '#')}

		# items list tests
	end
end
