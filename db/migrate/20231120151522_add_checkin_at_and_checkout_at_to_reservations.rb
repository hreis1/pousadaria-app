class AddCheckinAtAndCheckoutAtToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :checkin_at, :datetime
    add_column :reservations, :checkout_at, :datetime
  end
end
