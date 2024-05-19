require_relative "client"

module Discourse
  class Importer
    def self.import_usernames_for_group(group_name)
      discourse_client = Discourse::Client.new
      group_members = discourse_client.list_group_members(group_name)
      users = discourse_client.list_users

      group_members.each do |discourse_user|
        email = users[discourse_user["username"]]
        existing_user = Person.find_by(email:)
        unless existing_user
          puts "User with email #{email} not found"
          next
        end

        existing_user.update(
          discourse_username: discourse_user["username"],
          discourse_id: discourse_user["id"]
        )
      end
    end
  end
end
