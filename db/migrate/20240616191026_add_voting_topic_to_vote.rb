class AddVotingTopicToVote < ActiveRecord::Migration[7.1]
  def change
    add_reference :votes, :voting_topic, foreign_key: true
  end
end
