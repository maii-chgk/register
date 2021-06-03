class Assembly < ApplicationRecord
  has_and_belongs_to_many :people

  has_paper_trail

  rails_admin do
    exclude_fields :created_at, :updated_at, :id

    label "Собрание"
    label_plural "Собрания"

    configure :date do
      label "Дата"
    end
  end
end
