module Discourse
  class Client
    URL = "http://forum.znatoki.site"
    MAIN_GROUP = "organization_members"

    def initialize
      @client = DiscourseApi::Client.new(URL)
      @client.api_key = Rails.application.credentials.dig(:discourse_api, :key)
      @client.api_username = Rails.application.credentials.dig(:discourse_api, :username)
    end

    # Pagination in the users endpoint works using page numbers instead of offsets, so we don’t use `list_all`.
    def list_users
      page = 0
      all_users = {}

      loop do
        users = @client.list_users("active", {page:, show_emails: true})
        break if users.empty?

        users.each { |user| all_users[user["username"]] = user["email"] }
        page += 1
      end

      all_users
    end

    def list_group_members(group_name)
      list_all(:group_members, %w[name username id], group_name)
    end

    def add_to_group(group_name, *people)
      usernames = Array(people).flatten.map(&:discourse_username)
      @client.group_add(group_name, usernames)
    end

    def remove_from_group(group_name, *people)
      usernames = Array(people).flatten.map(&:discourse_username)
      @client.group_remove(group_name, usernames)
    end

    private

    def list_all(method, keys, *args)
      offset = 0
      limit = 100
      all_items = []

      loop do
        items = @client.send(method, *args, {offset:, limit:})
        break if items.empty?

        all_items += items.map { |item| item.slice(*keys) }
        offset += limit
      end

      all_items
    end
  end
end
