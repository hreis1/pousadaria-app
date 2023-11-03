class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.references :inn, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.integer :dimension
      t.integer :max_occupancy, default: 1
      t.integer :daily_rate
      t.boolean :has_bathroom, default: false
      t.boolean :has_balcony, default: false
      t.boolean :has_air_conditioning, default: false
      t.boolean :has_tv, default: false
      t.boolean :has_closet, default: false
      t.boolean :has_safe, default: false
      t.boolean :is_accessible, default: false
      t.boolean :is_available, default: true

      t.timestamps
    end
  end
end
