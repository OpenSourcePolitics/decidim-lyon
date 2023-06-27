# frozen_string_literal: true

namespace :decidim_app do
  desc "Create admin user with decidim_app:create_admin name='John Doe' nickname='johndoe' email='john@example.org', password='decidim123456' organization_id='1'"
  task create_admin: :environment do
    Decidim::AdminCreator.create!(ENV) ? puts("Admin created successfully") : puts("Admin creation failed")
  end

  desc "Create system user with decidim_app:create_system_admin email='john@example.org', password='decidim123456'"
  task create_system_admin: :environment do
    Decidim::SystemAdminCreator.create!(ENV) ? puts("System admin created successfully") : puts("System admin creation failed")
  end

  # This task is used to upgrade your decidim-app to the latest version
  # Meant to be used in a CI/CD pipeline or a k8s job/operator
  # You can add your own customizations here
  desc "Upgrade decidim-app"
  task upgrade: :environment do
    puts "Running db:migrate"
    Rake::Task["db:migrate"].invoke
  end
end
