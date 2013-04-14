class FixColumnTypeNameInHome < ActiveRecord::Migration
  def change
  	rename_column :homes, :type, :home_type
  end
end
