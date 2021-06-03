class AddCyrillicNameToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :cyrillic_name, :string
  end
end
