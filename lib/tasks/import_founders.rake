require_relative "../discourse/importer"

desc "Import founding members"
task :import_founding_members => :environment do
  DiscourseImporter.import_group("organization_members", "2021-04-11")
end
