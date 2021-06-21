class Person < ApplicationRecord
  has_and_belongs_to_many :assemblies, -> { distinct }

  after_update set_discourse_role
  after_destroy unset_discourse_role

  has_paper_trail

  rails_admin do
    exclude_fields :created_at, :updated_at, :id

    label "Человек"
    label_plural "Люди"

    configure :name do
      label "Имя"
    end

    configure :cyrillic_name do
      label "Имя кириллицей"
    end

    configure :start_date do
      label "Дата вступления"
    end
  end

  private

  def set_discourse_role
    DiscourseClient.add_to_group(email, DiscourseClient::MAIN_GROUP)
  end

  def unset_discourse_role
    DiscourseClient.remove_from_group(email, DiscourseClient::MAIN_GROUP)
  end
end
