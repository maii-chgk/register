class Assembly < ApplicationRecord
  has_many :votes

  def self.for_date(date)
    Assembly.where("start_date <= ? and end_date >= ?", date, date).first
  end
end
