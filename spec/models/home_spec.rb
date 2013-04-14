# == Schema Information
#
# Table name: homes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  location   :string(255)
#  home_type  :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Home do
  let(:user) {FactoryGirl.create(:user)}

  before {@home = user.homes.build(home_type: "House", name: "My house", location: "Burleson, Texas")}

  subject {@home}

  it {should respond_to(:home_type)}
  it {should respond_to(:user_id)}
  it {should respond_to(:name)}
  it {should respond_to(:location)}
  it {should respond_to(:user)}
  its(:user) {should == user}

  it {should be_valid}

  describe "when user id is not present" do
  	before {@home.user_id = nil}
  	it {should_not be_valid}
  end

  describe "with a blank name" do
  	before {@home.name = " "}
  	it {should_not be_valid}
  end

  describe "with a name that's too long" do
  	before {@home.name = "a" * 51}
  	it {should_not be_valid}
  end

  describe "with a location that's too long" do
  	before {@home.location = "a" * 51}
  	it {should_not be_valid}
  end

  describe "accessible attributes" do
  	it "should not allow access to user_id" do
  		expect do
  			Home.new(user_id: user.id)
		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
	end
  end
end
