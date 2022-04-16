class DropPaymentPeople < ActiveRecord::Migration[6.1]
  def change
    drop_table :payments_people
  end
end
