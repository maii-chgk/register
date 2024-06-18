module Discourse
  class Client
    URL = "https://forum.znatoki.site"
    MAIN_GROUP = "organization_members"
    MAIN_GROUP_ID = 57
    SUSPENDED_GROUP = "suspended"
    SUSPENDED_GROUP_ID = 67

    attr_reader :connection

    def initialize
      @connection = Faraday.new(url: URL) do |connection|
        connection.request :url_encoded
        connection.adapter Faraday.default_adapter
        connection.headers["Api-Key"] = Rails.application.credentials.dig(:discourse_api, :key)
        connection.headers["Api-Username"] = Rails.application.credentials.dig(:discourse_api, :username)
        connection.headers["Accept"] = "application/json"
        connection.response :json, content_type: "application/json"
        connection.request :retry, max: 3, interval: 1, backoff_factor: 2, retry_statuses: [429]
      end
    end

    def list_users
      page = 0
      all_users = {}
      loop do
        users = connection.get("/admin/users/list/active.json", {page:, show_emails: true}).body
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
        items = connection.get("groups/#{group_name}/members.json", {offset:, limit:}).body["members"]
        break if items.empty?

        all_members += items.pluck("id", "name", "username")
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

    def list_all_voters_for_topic(topic_id)
      post = get_first_post(topic_id)
      polls_div = Nokogiri::HTML(post["cooked"]).css(".poll")
      polls_count = polls_div.size
      return [] if polls_count == 0

      voters = Set.new
      poll_names = polls_div.map { |poll_div| poll_div["data-poll-name"] }
      poll_names.each do |poll_name|
        Rails.logger.info "Listing voters for poll #{poll_name} in topic #{topic_id}"
        voters.merge(list_voters(post["id"], poll_name))
        sleep 1
      end
      voters
    end

    private

    def get_first_post(topic_id)
      connection
        .get("/t/#{topic_id}.json")
        .body
        .dig("post_stream", "posts")
        .first
        .slice("id", "cooked")
    end

    def list_voters(post_id, poll_name)
      page = 1
      all_voters = []

      loop do
        voters = connection.get("/polls/voters.json", {post_id:, page:, poll_name:})
          .body["voters"]

        if voters.blank?
          Rails.logger.warn "No voters found for poll #{poll_name} in post #{post_id}" if all_voters.empty?
          break
        end

        all_voters += voters.values.flatten.pluck("username", "id")
        page += 1
      end

      all_voters
    end

    def update_group_members(group_id, method, *people)
      usernames = Array(people).flatten.map(&:discourse_username).compact.join(",")

      connection.send(method) do |req|
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
