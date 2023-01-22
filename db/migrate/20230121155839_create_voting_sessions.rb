class CreateVotingSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :voting_sessions do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    add_reference :votes, :voting_session, foreign_key: true
  end
end
