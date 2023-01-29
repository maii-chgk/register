class Vote < ApplicationRecord
  belongs_to :person, -> { distinct }
  belongs_to :assembly, optional: true
  belongs_to :voting_session, optional: true

  has_paper_trail

  ELECTRONIC_VOTING_DATES = ["2021-07-23",
                             "2021-08-01", "2021-08-06", "2021-08-15", "2021-08-29",
                             "2021-09-12", "2021-09-14",
                             "2022-01-05",
                             "2022-08-04", "2022-08-21", "2022-08-22", "2022-08-23",
                             "2022-09-04"]
  ASSEMBLIES_DATES = ["2021-05-29", "2021-07-03", "2022-04-30", "2022-08-28", "2022-12-18"]

  rails_admin do
    exclude_fields :created_at, :updated_at, :id

    label "Голосование"
    label_plural "Голосования"

    configure :date do
      label "Дата"
    end
  end
end
