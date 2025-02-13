# frozen_string_literal: true

require "active_support/concern"
module UserExtends
  extend ActiveSupport::Concern

  included do
    def needs_password_update?
      return false if organization.users_registration_mode == "disabled"
      return false unless admin?
      return false unless Decidim.config.admin_password_strong
      return true if password_updated_at.blank?

      password_updated_at < Decidim.config.admin_password_expiration_days.days.ago
    end

    def moderator?
      Decidim.participatory_space_manifests.map do |manifest|
        participatory_space_type = manifest.model_class_name.constantize
        return true if participatory_space_type.moderators(organization).exists?(id)
      end
      false
    end
  end
end

Decidim::User.include(UserExtends)
