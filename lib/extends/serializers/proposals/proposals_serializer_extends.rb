# frozen_string_literal: true

module ProposalSerializerExtends
  # Public: Exports a hash with the serialized data for this proposal.
  def serialize
    {
      id: proposal.id,
      category: {
        id: proposal.category.try(:id),
        name: proposal.category.try(:name) || empty_translatable
      },
      scope: {
        id: proposal.scope.try(:id),
        name: proposal.scope.try(:name) || empty_translatable
      },
      participatory_space: {
        id: proposal.participatory_space.id,
        url: Decidim::ResourceLocatorPresenter.new(proposal.participatory_space).url
      },
      component: { id: component.id },
      title: proposal.title,
      body: convert_to_plain_text(proposal.body),
      address: proposal.address,
      latitude: proposal.latitude,
      longitude: proposal.longitude,
      state: proposal.state.to_s,
      reference: proposal.reference,
      answer: ensure_translatable(proposal.answer),
      supports: proposal.proposal_votes_count,
      endorsements: {
        total_count: proposal.endorsements.count,
        user_endorsements: user_endorsements
      },
      comments: proposal.comments_count,
      attachments: proposal.attachments.count,
      attachment_urls: attachment_urls,
      followers: proposal.followers.count,
      published_at: proposal.published_at,
      url: url,
      meeting_urls: meetings,
      related_proposals: related_proposals,
      is_amend: proposal.emendation?,
      original_proposal: {
        title: proposal&.amendable&.title,
        url: original_proposal_url
      }
    }
  end

  def attachment_urls
    proposal.attachments.map do |attc|
      Rails.application.routes.url_helpers.rails_blob_url(attc.file.blob, host: proposal.participatory_space.organization.host)
    end.join(",")
  end
end

Decidim::Proposals::ProposalSerializer.class_eval do
  prepend(ProposalSerializerExtends)
end
