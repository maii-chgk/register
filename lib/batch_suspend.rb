# frozen_string_literal: true

class BatchSuspend
  def self.run(emails_string)
    new(emails_string).run
  end

  def initialize(emails_string)
    @emails = emails_string
      .lines(chomp: true)
      .map(&:strip)
      .map(&:downcase)
      .reject(&:empty?)
  end

  def run
    unprocessed = []
    @emails.each do |email|
      person = Person.find_by(email:, accepted: true)
      unless person
        Rails.logger.warn "person with email #{email} missing"
        unprocessed << email
        next
      end

      person.suspended = true
      person.save
      Rails.logger.info "suspended #{person.name} (#{person.email})"
      sleep 1
    end
    unprocessed
  end
end
