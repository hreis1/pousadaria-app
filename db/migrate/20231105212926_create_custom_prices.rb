class CreateCustomPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_prices do |t|
      t.references :room, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.decimal :price

      t.timestamps
    end
  end
end
