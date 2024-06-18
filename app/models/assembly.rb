class Assembly < ApplicationRecord
  has_paper_trail
  has_many :votes
  has_many :voting_topics

  def self.for_date(date)
    Assembly.where("start_date <= ? and end_date >= ?", date, date).first
  end

  def votes_count
    votes.count
  end

  def voters_count
    votes.select(:person_id).distinct.count
  end

  rails_admin do
    configure :start_date do
      label "Дата начала"
    end

    configure :end_date do
      label "Дата окончания"
    end

    configure :votes_count do
      label "Голоса"
    end

    configure :voters_count do
      label "Участники"
    end

    list do
      field :id
      field :start_date
      field :end_date
      field :votes_count
      field :voters_count
    end

    show do
      field :start_date
      field :end_date
      field :votes_count
      field :voters_count
    end

    edit do
      field :start_date
      field :end_date
    end

    label "Общее собрание"
    label_plural "Общие собрания"
  end
end
