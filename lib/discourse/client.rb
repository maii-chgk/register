require 'date'
require_relative '../connection_manager'

class DiscourseClient
  MAIN_GROUP = "organization_members"

  class << self

    def list_group_members(group_name: MAIN_GROUP)
      query = <<~SQL
        select users.name, ue.email
        from users
        join group_users on users.id = group_users.user_id
        join groups on group_users.group_id = groups.id
        join user_emails ue on users.id = ue.user_id
        where groups.name = $1
      SQL

      execute(query, group_name).to_a
    end

    def list_voters(day, group_name: MAIN_GROUP)
      group_filter = if group_name.nil?
                       ""
                     else
                       "where p.groups = '#{group_name}'"
                     end

      query = <<~SQL
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

    def add_to_group(email, group_name)
      group_id = fetch_group_id(group_name)
      user_id = fetch_user_id(email)

      return if already_in_group?(group_id, user_id)

      query = <<~SQL
        insert into groups_users (group_id, user_id, created_at, updated_at)
        values ($1, $2, now(), now())
      SQL

      execute(query, [group_id, user_id])
    end

    def already_in_group?(group_id, user_id)
      query = <<~SQL
        select from group_users
        where user_id = $1
            and group_id = $2;
      SQL

      execute(query, [group_id, user_id]).num_tuples.positive?
    end

    def remove_from_group(email, group_name)
      group_id = fetch_group_id(group_name)
      user_id = fetch_user_id(email)
      query = <<~SQL
        delete from group_users
        where user_id = $1
            and group_id = $2;
      SQL

      execute(query, [group_id, user_id])
    end

    def fetch_group_id(group_name)
      query = <<~SQL
        select id
        from groups
        where groups.name = $1;
      SQL

      execute(query, group_name)
    end

    def fetch_user_id(email)
      query = <<~SQL
        select user_id
        from user_emails
        where email = $1
      SQL

      execute(query, email)
    end

    def execute(query, params)
      params = [params] unless params.kind_of?(Array)

      ConnectionManager.connection_pool.with do |connection|
        connection.exec_params(query, params)
      end
    end
  end
end