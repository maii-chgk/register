class Assembly < ApplicationRecord
  belongs_to :person, -> { distinct }

  has_paper_trail

  rails_admin do
    exclude_fields :created_at, :updated_at, :id

    label "Участие в ОС"
    label_plural "Участия в ОС"

    configure :date do
      label "Дата"
    end
  end
end
