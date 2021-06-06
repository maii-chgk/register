require 'date'
require_relative './connection_manager'

class DiscourseClient
  DEFAULT_GROUP = "organization_members"

  def self.list_group_members(group_name: DEFAULT_GROUP)
    query = <<-SQL
      select users.name, ue.email
      from users
      join group_users on users.id = group_users.user_id
      join groups on group_users.group_id = groups.id
      join user_emails ue on users.id = ue.user_id
      where groups.name = $1
    SQL

    execute(query, group_name).to_a
  end

  def self.list_voters(day, group_name: DEFAULT_GROUP)
    group_filter = if group_name.nil?
                     ""
                   else
                     "where p.groups = '#{group_name}'"
                   end

    query = <<-SQL
      with poll_dates as (
          select p.id, min(poll_votes.created_at) as poll_start,
                 max(poll_votes.created_at) as poll_finish
          from polls p
          join poll_votes on p.id = poll_votes.poll_id
          #{group_filter}
          group by p.id
      )
      
      select distinct ue.email
      from poll_dates pd
      join poll_votes on pd.id = poll_votes.poll_id
      join user_emails ue on poll_votes.user_id = ue.user_id
      where poll_start >= $1 and poll_finish < $2
    SQL

    next_day = Date.parse(day) + 1
    execute(query, [day, next_day]).to_a
  end

  def self.execute(query, params)
    params = [params] unless params.kind_of?(Array)

    ConnectionManager.connection_pool.with do |connection|
      connection.exec_params(query, params)
    end
  end
end