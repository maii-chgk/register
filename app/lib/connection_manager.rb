class ConnectionManager
  @pool = nil
  @mutex = Mutex.new

  class << self
    def connection_pool
      @pool || create_pool
    end

    private

    def create_pool
      @mutex.synchronize do
        return @pool if @pool

        @pool = ConnectionPool.new(size: 5) do
          PG.connect(
            host: Rails.application.credentials.discourse_db[:host],
            port: Rails.application.credentials.discourse_db[:port],
            user: Rails.application.credentials.discourse_db[:user],
            password: Rails.application.credentials.discourse_db[:password],
            dbname: Rails.application.credentials.discourse_db[:dbname]
          )
        end
      end
    end

  end
end