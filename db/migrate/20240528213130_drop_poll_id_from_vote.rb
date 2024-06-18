class DropPollIdFromVote < ActiveRecord::Migration[7.1]
  def change
    remove_column :votes, :poll_id, :integer
  end
end
