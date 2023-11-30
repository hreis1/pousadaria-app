class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rates do |t|
      t.integer :rating
      t.text :review
      t.text :response
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
