# frozen_string_literal: true

module Decidim
  module UserPresenterConcern
    extend ActiveSupport::Concern

    included do
      def has_tooltip?
        false
      end
    end
  end
end
