require 'connection_pool'

Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT']) }