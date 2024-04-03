# frozen_string_literal: true

require "decidim/notifications_digest"

class NotificationsDigestMailJob < ApplicationJob
  queue_as :scheduled

  def perform(frequency)
    Decidim::NotificationsDigest.notifications_digest(frequency.to_sym)
  end
end
