class DropAssemblyParticipations < ActiveRecord::Migration[6.1]
  def change
    drop_table :assembly_participations
  end
end
