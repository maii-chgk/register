class RenameVerifiedToAcceptedInPerson < ActiveRecord::Migration[6.1]
  def change
    rename_column :people, :verified, :accepted
  end
end
