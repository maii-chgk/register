require_relative "../../app/lib/discourse/importer"

desc "Import founding members"
task import_founding_members: :environment do
  Discourse::Importer.import_group("organization_members", "2021-04-11")
end
