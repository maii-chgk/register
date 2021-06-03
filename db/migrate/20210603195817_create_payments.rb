class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.date :date
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end

    create_join_table :payments, :people do |t|
      t.index :payment_id
      t.index :person_id
    end
  end
end
