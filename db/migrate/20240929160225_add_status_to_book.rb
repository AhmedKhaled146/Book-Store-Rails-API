class AddStatusToBook < ActiveRecord::Migration[7.2]
  def change
    add_column :books, :status, :boolean, default: false, null: false
  end
end
