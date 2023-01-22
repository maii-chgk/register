class VotingSession < ApplicationRecord
  def self.for_date(date)
    VotingSession.where("start_date <= ? and end_date >= ?", date, date).first
  end
end
