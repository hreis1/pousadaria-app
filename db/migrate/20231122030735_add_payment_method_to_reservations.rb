class AddPaymentMethodToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :payment_method, :string
  end
end
