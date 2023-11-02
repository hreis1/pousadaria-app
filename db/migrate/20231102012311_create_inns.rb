class CreateInns < ActiveRecord::Migration[7.0]
  def change
    create_table :inns do |t|
      t.references :owner, null: false, foreign_key: true
      t.string :trade_name
      t.string :corporate_name
      t.string :cnpj
      t.string :phone
      t.string :email
      t.string :address
      t.string :address_number
      t.string :neighborhood
      t.string :state
      t.string :city
      t.string :cep
      t.string :description
      t.string :payment_methods
      t.boolean :pets_allowed
      t.string :polices
      t.time :checkin_time
      t.time :checkout_time
      t.boolean :status

      t.timestamps
    end
  end
end
