# frozen_string_literal: true

return unless defined?(Decidim::SimpleProposal)

Decidim::SimpleProposal.configure do |config|
  config.require_category = !Rails.env.test?
  config.require_scope = !Rails.env.test?
end
