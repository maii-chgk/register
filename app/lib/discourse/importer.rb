require_relative "client"

module Discourse
  class Importer
    def self.import_usernames_for_group(group_name)
      discourse_client = Discourse::Client.new
      group_members = discourse_client.list_group_members(group_name)
      users = discourse_client.list_users

      group_members.each do |discourse_id, _discourse_name, discourse_username|
        email = users[discourse_username]
        existing_user = Person.find_by(email:)
        unless existing_user
          Rails.logger.warn "User with email #{email} not found"
          next
        end

        existing_user.update(discourse_username:, discourse_id:)
      end
    end
  end
end
