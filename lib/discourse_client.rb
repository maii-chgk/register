require_relative './connection_manager'

class DiscourseClient
  def self.list_group_members(group_name)
    query = <<-SQL
      select users.name, ue.email
      from users
      join group_users on users.id = group_users.user_id
      join groups on group_users.group_id = groups.id
      join user_emails ue on users.id = ue.user_id
      where groups.name = $1
    SQL

    ConnectionManager.connection_pool.with do |connection|
      connection.exec_params(query, [group_name]).to_a
    end
  end
end