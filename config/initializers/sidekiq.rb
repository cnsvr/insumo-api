# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }

  config.logger = Sidekiq::Logger.new(ENV.fetch('SIDEKIQ_LOG_PATH', Rails.root.join("log/#{Rails.env}_sidekiq.log")))
  config.logger.level = Rails.logger.level
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end
