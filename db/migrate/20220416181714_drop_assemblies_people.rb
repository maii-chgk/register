class DropAssembliesPeople < ActiveRecord::Migration[6.1]
  def change
    drop_table :assemblies_people
  end
end
