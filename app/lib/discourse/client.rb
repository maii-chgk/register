module Discourse
  class Client
    URL = "https://forum.znatoki.site"
    MAIN_GROUP = "organization_members"
    MAIN_GROUP_ID = 57

    def initialize
      @connection = Faraday.new(url: URL) do |connection|
        connection.request :url_encoded
        connection.adapter Faraday.default_adapter
        connection.headers["Api-Key"] = Rails.application.credentials.dig(:discourse_api, :key)
        connection.headers["Api-Username"] = Rails.application.credentials.dig(:discourse_api, :username)
        connection.headers["Accept"] = "application/json"
        connection.response :json, content_type: "application/json"
      end
    end

    def list_users
      page = 0
      all_users = {}
      loop do
        users = @connection.get("/admin/users/list/active.json", {page:, show_emails: true}).body
        break if users.empty?

        users.each { |user| all_users[user["username"]] = user["email"] }
        page += 1
      end

      all_users
    end

    def list_group_members(group_name)
      offset = 0
      limit = 100
      all_members = []

      loop do
        items = @connection.get("groups/#{group_name}/members.json", {offset:, limit:}).body["members"]
        break if items.empty?

        all_members += items.map { |item| item.slice("id", "name", "username") }
        offset += limit
      end

      all_members
    end

    def add_to_group(group_id, *people)
      update_group_members(group_id, :put, people)
    end

    def remove_from_group(group_id, *people)
      update_group_members(group_id, :delete, people)
    end

    private

    def update_group_members(group_id, method, *people)
      usernames = Array(people).flatten.map(&:discourse_username).compact.join(",")

      @connection.send(method) do |req|
        req.url "/groups/#{group_id}/members.json"
        req.body = {usernames:}
      end
    end

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
