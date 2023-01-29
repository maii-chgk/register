class RenameAssemblyModel < ActiveRecord::Migration[6.1]
  def change
    rename_table :assemblies, :assembly_participations
    rename_index :assembly_participations, :index_assemblies_on_person_id, :index_assembly_participations_on_person_id
  end
end
