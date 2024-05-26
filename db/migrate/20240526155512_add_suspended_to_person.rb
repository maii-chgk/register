class AddSuspendedToPerson < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :suspended, :boolean
  end
end
