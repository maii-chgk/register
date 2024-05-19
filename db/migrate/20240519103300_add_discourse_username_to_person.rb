class AddDiscourseUsernameToPerson < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :discourse_username, :string
  end
end
