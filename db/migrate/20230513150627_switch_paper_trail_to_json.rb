class SwitchPaperTrailToJson < ActiveRecord::Migration[7.0]
  def change
    add_column :versions, :new_object, :json
    add_column :versions, :new_object_changes, :json

    PaperTrail::Version.where.not(object: nil).find_each do |version|
      version.update_column(:new_object, YAML.load(version.object))

      if version.object_changes
        version.update_column(
          :new_object_changes,
          YAML.load(version.object_changes)
        )
      end
    end

    remove_column :versions, :object
    remove_column :versions, :object_changes
    rename_column :versions, :new_object, :object
    rename_column :versions, :new_object_changes, :object_changes
  end
end
