require_relative "../../app/lib/discourse/client"

desc "Import votes"
task :import_votes => :environment do
  votes = Discourse::Client.get_votes

  votes.each do |vote|
    email, date = vote['email'], vote['date']
    person = Person.find_by(email: email)
    if person.nil?
      puts "person with email #{email} missing"
      next
    end

    kind = if Vote::ASSEMBLIES_DATES.include?(date)
             :assembly
           elsif Vote::ELECTRONIC_VOTING_DATES.include?(date)
            :electronic
           else
             :random
           end
    Vote.find_or_create_by(date: date, person: person, kind: kind)
  end
end
