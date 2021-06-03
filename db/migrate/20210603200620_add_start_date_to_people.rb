class AddStartDateToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :start_date, :date
  end
end
