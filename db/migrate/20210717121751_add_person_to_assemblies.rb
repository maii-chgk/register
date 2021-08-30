class AddPersonToAssemblies < ActiveRecord::Migration[6.1]
  def change
    add_reference :assemblies, :person, null: false, foreign_key: true
  end
end
