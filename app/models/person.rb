class Person < ApplicationRecord
  has_and_belongs_to_many :assemblies, -> { distinct }

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
end
