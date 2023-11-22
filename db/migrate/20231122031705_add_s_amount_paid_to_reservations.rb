class AddSAmountPaidToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :amount_paid, :string
    add_column :reservations, :integer, :string
  end
end
