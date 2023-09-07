# frozen_string_literal: true

require "decidim/dev"
Decidim::Dev.dummy_app_path = File.expand_path(Rails.root.to_s)
require "decidim/dev/test/base_spec_helper"

Dir.glob("./spec/support/**/*.rb").sort.each { |f| require f }

RSpec.configure do |config|
  config.formatter = ENV.fetch("RSPEC_FORMAT", "progress").to_sym
  config.include EnvironmentVariablesHelper

  config.before do
    # Initializers configs
    Decidim.enable_html_header_snippets = false
    SocialShareButton.configure do |social_share_button|
      social_share_button.allow_sites = %w(twitter facebook whatsapp_app whatsapp_web telegram)
    end

    Decidim::Verifications.register_workflow(:dummy_authorization_handler) do |auth|
      auth.form = "DummyAuthorizationHandler"
    end
  end
end
