# frozen_string_literal: true

require_relative "boot"

require "decidim/rails"

# TODO : add missing dep to decidim-initiatives/lib/decidim/initiatives/engine.rb
# require "wicked_pdf"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DevelopmentApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.time_zone = "Europe/Paris" unless Rails.env.test?
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.yml").to_s]

    # This needs to be set for correct images URLs in emails
    # DON'T FORGET to ALSO set this in `config/initializers/carrierwave.rb`

    config.action_mailer.asset_host = "https://oye.participer.lyon.fr" if Rails.env.production?

    config.backup = config_for(:backup).deep_symbolize_keys

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.after_initialize do
      require "extends/controllers/decidim/devise/sessions_controller_extends"
      require "extends/controllers/decidim/budgets/projects_controller_extends"
    end
  end
end
