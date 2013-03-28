# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  model        :string(255)
#  purchasedate :datetime
#  quantity     :integer
#  serialnum    :string(255)
#  location     :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Item < ActiveRecord::Base
  attr_accessible :location, :model, :name, :purchasedate, :quantity, :serialnum
end
