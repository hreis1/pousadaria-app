class AddRatingAndReviewToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :rating, :integer
    add_column :reservations, :review, :text
  end
end
