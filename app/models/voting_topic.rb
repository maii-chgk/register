class VotingTopic < ApplicationRecord
  belongs_to :assembly, optional: true
  belongs_to :voting_session, optional: true
  has_many :votes

  rails_admin do
    exclude_fields :created_at, :updated_at, :id, :votes

    label "Тема с голосованиями"
    label_plural "Темы с голосованиями"
  end
end
