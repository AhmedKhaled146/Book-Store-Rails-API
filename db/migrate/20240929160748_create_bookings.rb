class CreateBookings < ActiveRecord::Migration[7.2]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.datetime :starting_date, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :ending_date, null: false

      t.timestamps
    end
  end
end
