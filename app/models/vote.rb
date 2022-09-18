class Vote < ApplicationRecord
  enum kind: {
    random: 0,
    assembly: 1,
    electronic: 2
  }, _default: :random

  belongs_to :person, -> { distinct }

  has_paper_trail

  ELECTRONIC_VOTING_DATES = ["2021-07-23",
                             "2021-08-01", "2021-08-06", "2021-08-15", "2021-08-29",
                             "2021-09-12", "2021-09-14",
                             "2022-01-05",
                             "2022-08-04", "2022-08-21", "2022-08-22", "2022-08-23",
                             "2022-09-04"]
  ASSEMBLIES_DATES = ["2021-05-29", "2021-07-03", "2022-04-30", "2022-08-28"]

  def self.assemblies_between(first_date, second_date)
    Vote.where(["date between ? and ?", first_date, second_date])
      .assembly
      .select(:date)
      .distinct
      .sort
      .pluck(:date)
  end

  rails_admin do
    exclude_fields :created_at, :updated_at, :id

    label "Голосование"
    label_plural "Голосования"

    configure :date do
      label "Дата"
    end
  end
end
