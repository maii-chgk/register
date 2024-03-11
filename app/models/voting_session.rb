class VotingSession < ApplicationRecord
  has_paper_trail
  has_many :votes

  def self.for_date(date)
    VotingSession.where("start_date <= ? and end_date >= ?", date, date).first
  end

  def votes_count
    votes.count
  end

  def voters_count
    votes.select(:person_id).distinct.count
  end

  rails_admin do
    exclude_fields :created_at, :updated_at, :id, :votes

    label "Электронное голосование"
    label_plural "Электронные голосования"

    configure :start_date do
      label "Дата начала"
    end

    configure :end_date do
      label "Дата окончания"
    end

    field :votes_count do
      label "Голоса"
    end

    field :voters_count do
      label "Участники"
    end
  end
end
