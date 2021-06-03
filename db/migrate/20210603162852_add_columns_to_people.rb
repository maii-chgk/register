class AddColumnsToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :name, :string
    add_column :people, :email, :string
  end
end
