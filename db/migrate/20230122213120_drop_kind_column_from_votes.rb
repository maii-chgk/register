class DropKindColumnFromVotes < ActiveRecord::Migration[6.1]
  def change
    remove_column :votes, :kind
  end
end
