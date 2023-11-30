class RemoveRatingAndReviewFromReservations < ActiveRecord::Migration[7.0]
  def change
    remove_column :reservations, :rating, :integer
    remove_column :reservations, :review, :text
  end
end
