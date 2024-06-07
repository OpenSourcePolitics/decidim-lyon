
return unless defined?(Decidim::SimpleProposal)

Decidim::SimpleProposal.configure do |config|
  config.require_category = true
  config.require_scope = true
end
