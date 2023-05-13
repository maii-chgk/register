class Assembly < ApplicationRecord
  has_paper_trail
  has_many :votes

  def self.for_date(date)
    Assembly.where("start_date <= ? and end_date >= ?", date, date).first
  end

  rails_admin do
    exclude_fields :created_at, :updated_at, :id

    label "Общее собрание"
    label_plural "Общие собрания"

    configure :start_date do
      label "Дата начала"
    end

    configure :end_date do
      label "Дата окончания"
    end
  end
end
