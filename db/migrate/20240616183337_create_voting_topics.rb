class CreateVotingTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :voting_topics do |t|
      t.integer :topic_id
      t.references :assembly, null: true, foreign_key: true
      t.references :voting_session, null: true, foreign_key: true
      t.timestamps
    end
  end
end
