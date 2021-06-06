require_relative "../discourse_importer"

desc "Create and import assembly"
task :create_assembly => :environment do
  ARGV.each { |a| task a.to_sym do ; end }
  day = ARGV[1]
  raise ArgumentError, "Provide the assembly’s date" if day.nil?

  assembly = Assembly.find_or_create_by(date: day)
  voters = DiscourseClient.list_voters(day)
  voters.each do |voter|
    assembly.people << Person.find_by(email: voter["email"])
  end
end
