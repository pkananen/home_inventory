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

class Home < ActiveRecord::Base
  attr_accessible :location, :name, :home_type
  belongs_to :user

  validates :user_id, presence: true
  validates :name, presence: true, length: {maximum: 50}
  validates :location, length: {maximum: 50}
end
