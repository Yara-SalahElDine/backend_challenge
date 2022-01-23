# frozen_string_literal: true

require "sidekiq"
require "sidekiq-unique-jobs"

sidekiq_config = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/12" }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  SidekiqUniqueJobs::Server.configure(config)
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end