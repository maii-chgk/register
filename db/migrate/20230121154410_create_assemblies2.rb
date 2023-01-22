class CreateAssemblies2 < ActiveRecord::Migration[6.1]
  def change
    create_table :assemblies do |t|
      t.date :start_date
      t.date :end_date
      t.timestamps
    end

    add_reference :votes, :assembly, foreign_key: true
  end
end
