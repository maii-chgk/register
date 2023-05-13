class VotingSession < ApplicationRecord
  has_paper_trail
  has_many :votes

  def self.for_date(date)
    VotingSession.where("start_date <= ? and end_date >= ?", date, date).first
  end

  rails_admin do
    exclude_fields :created_at, :updated_at, :id

    label "Электронное голосование"
    label_plural "Электронные голосования"

    configure :start_date do
      label "Дата начала"
    end

    configure :end_date do
      label "Дата окончания"
    end
  end
end
