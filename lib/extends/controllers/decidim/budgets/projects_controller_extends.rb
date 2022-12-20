# frozen_string_literal: true

module ProjectsControllerExtends
  extend ActiveSupport::Concern

  included do
    def projects
      return @projects if @projects

      @projects = search.results
      @projects = reorder(@projects)
      @projects = @projects.page(params[:page]).per(current_component.settings.projects_per_page)
    end
  end
end

Decidim::Budgets::ProjectsController.class_eval do
  include(ProjectsControllerExtends)
end
