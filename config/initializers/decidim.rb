# frozen_string_literal: true

require "decidim_app/config"

Decidim.configure do |config|
  config.application_name = "OSP Agora"
  config.mailer_sender = "OSP Agora <ne-pas-repondre@opensourcepolitics.eu>"

  config.default_locale = ENV.fetch("DEFAULT_LOCALE", "en").to_sym
  config.available_locales = ENV.fetch("AVAILABLE_LOCALES", "en,fr,ca,es").split(",").map(&:to_sym)

  # Timeout session
  config.expire_session_after = ENV.fetch("DECIDIM_SESSION_TIMEOUT", 180).to_i.minutes

  config.maximum_attachment_height_or_width = 6000

  # Whether SSL should be forced or not (only in production).
  config.force_ssl = (ENV.fetch("FORCE_SSL", "1") == "1") && Rails.env.production?

  # Geocoder configuration
  config.maps = {
    provider: :here,
    api_key: Rails.application.secrets.maps[:api_key],
    # Keep HERE as the default provider for autocomplete
    autocomplete: {
      address_format: [%w(houseNumber street), "city", "country"]
    },
    # Change to OSM for dynamic maps to avoid usage limits from HERE
    dynamic: {
      provider: :osm,
      tile_layer: {
        url: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        attribution: %(
        &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors
      )
      }
    }
  }

  # Custom resource reference generator method
  # config.resource_reference_generator = lambda do |resource, feature|
  #   # Implement your custom method to generate resources references
  #   "1234-#{resource.id}"
  # end

  # Currency unit
  config.currency_unit = Rails.application.secrets.decidim[:currency]

  # The number of reports which an object can receive before hiding it
  # config.max_reports_before_hiding = 3

  # Custom HTML Header snippets
  #
  # The most common use is to integrate third-party services that require some
  # extra JavaScript or CSS. Also, you can use it to add extra meta tags to the
  # HTML. Note that this will only be rendered in public pages, not in the admin
  # section.
  #
  # Before enabling this you should ensure that any tracking that might be done
  # is in accordance with the rules and regulations that apply to your
  # environment and usage scenarios. This feature also comes with the risk
  # that an organization's administrator injects malicious scripts to spy on or
  # take over user accounts.
  #
  config.enable_html_header_snippets = true

  # SMS gateway configuration
  #
  # If you want to verify your users by sending a verification code via
  # SMS you need to provide a SMS gateway service class.
  #
  # An example class would be something like:
  #
  # class MySMSGatewayService
  #   attr_reader :mobile_phone_number, :code
  #
  #   def initialize(mobile_phone_number, code)
  #     @mobile_phone_number = mobile_phone_number
  #     @code = code
  #   end
  #
  #   def deliver_code
  #     # Actual code to deliver the code
  #     true
  #   end
  # end
  #
  config.sms_gateway_service = Rails.application.secrets.dig(:decidim, :sms_gateway, :service)

  # Etherpad configuration
  #
  # Only needed if you want to have Etherpad integration with Decidim. See
  # Decidim docs at docs/services/etherpad.md in order to set it up.
  #

  if Rails.application.secrets.etherpad[:server].present?
    config.etherpad = {
      server: Rails.application.secrets.etherpad[:server],
      api_key: Rails.application.secrets.etherpad[:api_key],
      api_version: Rails.application.secrets.etherpad[:api_version]
    }
  end

  config.base_uploads_path = "#{ENV.fetch("HEROKU_APP_NAME", nil)}/" if ENV["HEROKU_APP_NAME"].present?
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale

# Inform Decidim about the assets folder
Decidim.register_assets_path File.expand_path("app/packs", Rails.application.root)
