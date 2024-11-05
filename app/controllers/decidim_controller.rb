# frozen_string_literal: true

# Entry point for Decidim. It will use the `DecidimController` as
# entry point, but you can change what controller it inherits from
# so you can customize some methods.
class DecidimController < ApplicationController
  before_action :enable_rack_mini_profiler

  def enable_rack_mini_profiler
    Rack::MiniProfiler.authorize_request if profiler?
  end

  private

  def profiler?
    return false if Rails.application.secrets.dig(:profiler, :key).blank?

    request.headers["X-Rack-Mini-Profiler-UUID"] == Rails.application.secrets.dig(:profiler, :key)
  end
end
