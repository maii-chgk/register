class AddPollIdToVotes < ActiveRecord::Migration[6.1]
  def change
    add_column :votes, :poll_id, :integer
  end
end
