class Vote < ApplicationRecord
  belongs_to :person, -> { distinct }
  belongs_to :assembly, optional: true
  belongs_to :voting_session, optional: true

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
