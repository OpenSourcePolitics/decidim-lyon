# frozen_string_literal: true

module Decidim
  module Meetings
    module UpdateMeetingExtends
      def call
        return broadcast(:invalid) if form.invalid?

        transaction do
          update_meeting!
          send_notification if should_notify_followers?
          schedule_upcoming_meeting_notification if start_time_changed?
        end

        broadcast(:ok, meeting)
      end

      private

      def update_meeting!
        parsed_title = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.title, current_organization: form.current_organization).rewrite
        parsed_description = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.description, current_organization: form.current_organization).rewrite

        Decidim.traceability.update!(
          meeting,
          form.current_user,
          {
            scope: form.scope,
            category: form.category,
            title: { I18n.locale => parsed_title },
            description: { I18n.locale => parsed_description },
            end_time: form.end_time,
            start_time: form.start_time,
            address: form.address,
            latitude: form.latitude,
            longitude: form.longitude,
            location: { I18n.locale => form.location },
            location_hints: { I18n.locale => form.location_hints },
            author: form.current_user,
            decidim_user_group_id: form.user_group_id,
            registration_type: form.registration_type,
            registration_url: form.registration_url,
            available_slots: form.available_slots,
            registration_terms: { I18n.locale => form.registration_terms },
            registrations_enabled: form.registrations_enabled,
            type_of_meeting: form.clean_type_of_meeting,
            online_meeting_url: form.online_meeting_url,
            iframe_embed_type: form.iframe_embed_type,
            iframe_access_level: form.iframe_access_level
          },
          visibility: "public-only"
        )
      end
    end
  end
end

Decidim::Meetings::UpdateMeeting.class_eval do
  prepend Decidim::Meetings::UpdateMeetingExtends
end
