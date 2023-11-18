class AddNameAndCpfToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :cpf, :string
  end
end
