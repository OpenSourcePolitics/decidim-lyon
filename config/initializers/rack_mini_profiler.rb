# frozen_string_literal: true

require "rack-mini-profiler"

if Rails.env.production?
  Rack::MiniProfiler.config.storage_options = {
    url: ENV.fetch("REDIS_URL", nil),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
end
