class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.date :checkin
      t.date :checkout
      t.integer :number_of_guests
      t.integer :status, default: 0
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
