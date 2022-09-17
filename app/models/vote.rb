class Vote < ApplicationRecord
  enum kind: {
    random: 0,
    assembly: 1,
    electronic: 2
  }, _default: :random

  belongs_to :person, -> { distinct }

  has_paper_trail

  rails_admin do
    exclude_fields :created_at, :updated_at, :id

    label "Голосование"
    label_plural "Голосования"

    configure :date do
      label "Дата"
    end
  end
end
