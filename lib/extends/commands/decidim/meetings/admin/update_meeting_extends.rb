# frozen_string_literal: true

module Decidim
  module Meetings
    module Admin
      module UpdateMeetingExtends
        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            update_meeting!
            send_notification if should_notify_followers?
            schedule_upcoming_meeting_notification if meeting.published? && start_time_changed?
            update_services!
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
            scope: form.scope,
            category: form.category,
            title: parsed_title,
            description: parsed_description,
            end_time: form.end_time,
            start_time: form.start_time,
            online_meeting_url: form.online_meeting_url,
            registration_type: form.registration_type,
            registration_url: form.registration_url,
            registrations_enabled: form.registrations_enabled,
            type_of_meeting: form.clean_type_of_meeting,
            address: form.address,
            latitude: form.latitude,
            longitude: form.longitude,
            location: form.location,
            location_hints: form.location_hints,
            private_meeting: form.private_meeting,
            transparent: form.transparent,
            iframe_embed_type: form.iframe_embed_type,
            comments_enabled: form.comments_enabled,
            comments_start_time: form.comments_start_time,
            comments_end_time: form.comments_end_time,
            iframe_access_level: form.iframe_access_level
          )
        end
      end
    end
  end
end

Decidim::Meetings::Admin::UpdateMeeting.class_eval do
  prepend Decidim::Meetings::Admin::UpdateMeetingExtends
end
