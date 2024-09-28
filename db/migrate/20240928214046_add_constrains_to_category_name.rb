class AddConstrainsToCategoryName < ActiveRecord::Migration[7.2]
  def change
    change_column_null :categories, :name, false
  end
end
