require "date"
require_relative "../connection_manager"

module Discourse
  class DbClient
    MAIN_GROUP = "organization_members"

    class << self
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

      def execute(query)
        ConnectionManager.connection_pool.with do |connection|
          connection.exec(query)
        end
      end

      def execute_with_params(query, params)
        params = [params] unless params.is_a?(Array)

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
