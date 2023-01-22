class AddAssemblyToAssemblyParticipations < ActiveRecord::Migration[6.1]
  def change
    add_column :assembly_participations, :assembly_id, :integer
    remove_column :assembly_participations, :date
    add_foreign_key :assembly_participations, :assemblies
  end
end
