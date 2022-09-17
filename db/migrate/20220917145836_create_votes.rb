class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.datetime :date
      t.integer :person_id
      t.integer :kind

      t.timestamps
    end
  end
end
