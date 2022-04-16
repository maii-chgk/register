require_relative "../../app/lib/discourse/client"

desc "Create and import assembly"
task :create_assembly => :environment do
  ARGV.each { |a| task a.to_sym do ; end }
  day = ARGV[1]
  raise ArgumentError, "Provide the assembly’s date" if day.nil?

  voters = Discourse::Client.list_voters(day)
  puts "number of voters: #{voters.count}"

  voters.each do |voter|
    person = Person.find_by(email: voter["email"])
    if person.nil?
      puts "person with email #{voter['email']} missing"
      next
    end
    Assembly.find_or_create_by(date: day, person_id: person.id)
    puts "#{voter['email']} added"
  end
end
