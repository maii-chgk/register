require 'date'
require_relative '../connection_manager'

module Discourse
  class Client
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

        execute_with_params(query, group_name).to_a
      end

      def get_votes(group_name: MAIN_GROUP)
        group_filter = if group_name.nil?
                         ""
                       else
                         "where p.groups = '#{group_name}'"
                       end

        query = <<~SQL
          with poll_dates as (
              select p.id, min(poll_votes.created_at) as poll_start
              from polls p
              join poll_votes on p.id = poll_votes.poll_id
              #{group_filter}
              group by p.id
          )
          
          select distinct ue.email, pd.poll_start::date as date, pd.id as poll_id
          from poll_dates pd
          join poll_votes on pd.id = poll_votes.poll_id
          join user_emails ue on poll_votes.user_id = ue.user_id
        SQL

        execute(query).to_a
      end

      def add_to_group(email, group_name)
        group_id = fetch_group_id(group_name)
        return if group_id.nil?

        user_id = fetch_user_id(email)
        return if user_id.nil?

        query = <<~SQL
          insert into group_users (group_id, user_id, created_at, updated_at)
          values ($1, $2, now(), now())
        SQL

        execute_with_params(query, [group_id, user_id])
      rescue PG::UniqueViolation
        # Already added to the group
      end

      def remove_from_group(email, group_name)
        group_id = fetch_group_id(group_name)
        return if group_id.nil?

        user_id = fetch_user_id(email)
        return if user_id.nil?

        query = <<~SQL
          delete from group_users
          where user_id = $1
              and group_id = $2;
        SQL

        execute_with_params(query, [group_id, user_id])
      end

      def fetch_group_id(group_name)
        query = <<~SQL
          select id
          from groups
          where groups.name = $1;
        SQL

        execute_with_params(query, group_name).getvalue(0, 0)
      rescue ArgumentError
        nil
      end

      def fetch_user_id(email)
        query = <<~SQL
          select user_id
          from user_emails
          where email = $1
        SQL

        execute_with_params(query, email).getvalue(0, 0)
      rescue ArgumentError
        nil
      end

      def execute(query)
        ConnectionManager.connection_pool.with do |connection|
          connection.exec(query)
        end
      end

      def execute_with_params(query, params)
        params = [params] unless params.kind_of?(Array)

        ConnectionManager.connection_pool.with do |connection|
          connection.exec_params(query, params)
        rescue PG::UnableToSend, PG::ConnectionBad
          Rails.logger.warn("Reloading connection pool")
          ConnectionManager.connection_pool.reload
          Rails.logger.warn("Reloaded connection pool")
          sleep(1)
          Rails.logger.warn("Retrying query")
          retry
        end
      end
    end
  end
end