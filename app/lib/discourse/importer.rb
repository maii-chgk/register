require_relative "client"

module Discourse
  class Importer
    attr_reader :client

    def self.import_group(group_name, start_date)
      group_members = Discourse::DBClient.list_group_members(group_name: group_name)
      group_members.each do |discourse_user|
        Person.find_or_create_by(name: discourse_user["name"], email: discourse_user["email"]) do |person|
          person.start_date = start_date
        end
      end
    end
  end
end
