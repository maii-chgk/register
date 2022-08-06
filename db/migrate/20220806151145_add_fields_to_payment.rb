class AddFieldsToPayment < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :name, :string
    add_column :payments, :email, :string
    add_column :payments, :currency, :string, default: "EUR"
    add_column :payments, :amount, :decimal, precision: 8, scale: 2
    add_column :payments, :method, :integer, default: 0
    remove_column :payments, :person_id, :integer
  end
end
