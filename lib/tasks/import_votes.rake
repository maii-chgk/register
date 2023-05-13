require_relative "../../app/lib/discourse/client"

desc "Import votes"
task :import_votes => :environment do
  votes = Discourse::Client.get_votes

  votes.each do |vote|
    email, date, poll_id = vote['email'], vote['date'], vote['poll_id']
    person = Person.find_by(email: email)
    if person.nil?
      puts "person with email #{email} missing"
      next
    end

    assembly = Assembly.for_date(date)
    voting_session = VotingSession.for_date(date)

    Vote.create_or_find_by(date: date,
                           person: person,
                           poll_id: poll_id,
                           assembly: assembly,
                           voting_session: voting_session)
  end
end

desc "Import votes for date"
task :import_votes_for_date, [:date] => :environment do
  assembly = Assembly.for_date(date)
  voting_session = VotingSession.for_date(date)
  votes = Discourse::Client.get_votes
  date_votes = votes.select { |vote| vote['date'] == date }

  date_votes.each do |vote|
    person = Person.find_by(email: vote['email'])
    if person.nil?
      puts "person with email #{email} missing"
      next
    end

    Vote.create_or_find_by(date: vote['date'],
                           person: person,
                           poll_id: vote['poll_id'],
                           assembly: assembly,
                           voting_session: voting_session)
  end
end
