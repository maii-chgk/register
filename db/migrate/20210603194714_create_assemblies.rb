class CreateAssemblies < ActiveRecord::Migration[6.1]
  def change
    create_table :assemblies do |t|
      t.date :date

      t.timestamps
    end

    create_join_table :assemblies, :people do |t|
      t.index :assembly_id
      t.index :person_id
    end
  end
end
