class RenameColunmStatusFromInn < ActiveRecord::Migration[7.0]
  def change
    rename_column :inns, :status, :active
  end
end
