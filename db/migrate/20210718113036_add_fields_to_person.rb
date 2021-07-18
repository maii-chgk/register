class AddFieldsToPerson < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :verified, :boolean, default: false
    add_column :people, :end_date, :datetime
    add_column :people, :newsletter, :boolean, default: false
  end
end
