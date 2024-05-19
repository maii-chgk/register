require_relative "../../app/lib/discourse/client"

desc "Import votes"
task import_usernames: :environment do
  Discourse::Importer.import_usernames_for_group("organization_members")
end
