class AddConstrainsToBooks < ActiveRecord::Migration[7.2]
  def change
    change_column_null :books, :title, false
    change_column_null :books, :author, false
    change_column_null :books, :description, false
  end
end
