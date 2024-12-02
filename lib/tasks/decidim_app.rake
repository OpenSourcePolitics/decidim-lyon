# frozen_string_literal: true

require "decidim_app/k8s/configuration_exporter"
require "decidim_app/k8s/organization_exporter"
require "decidim_app/k8s/manager"

namespace :decidim_app do
  desc "Exports proposals from process"
  task export_proposals: :environment do
    host = "oye.participer.lyon.fr"
    pp = Decidim::ParticipatoryProcess.find_by(slug: "bp2022")
    component = Decidim::Component.find(1)
    proposals = Decidim::Proposals::Proposal.includes(:attachments).where(component: component).state_published
    props = proposals.map do |prop|
      proposal_h = {}
      proposal_h = proposal_h.merge(prop.attributes)
      proposal_h[:attachments] = prop.attachments.map do |attc|
        Rails.application.routes.url_helpers.rails_blob_url(attc.file.blob, host: host)
      end

      proposal_h
    end

    byebug

    puts proposal_h
    #  attc = proposals[0..100].select { |prop| prop.attachments.present? }
    #  attc.first.attachments.first.file_blob.representation(resize_to_limit: [100, 100]).processed.url

    # Find URL : Rails.application.routes.url_helpers.rails_blob_url(ActiveStorage::Blob.find(245), host: "oye.participer.lyon.fr")
  end

  desc "Setup Decidim-app"
  task setup: :environment do
    # :nocov:
    puts "Running bundler installation"
    system("bundle install")
    puts "Installing engine migrations..."
    system("bundle exec rake railties:install:migrations")
    puts "Checking for migrations to apply..."
    migrations = `bundle exec rake db:migrate:status | grep down`
    if migrations.present?
      puts "Missing migrations :
#{migrations}"
      puts "Applying missing migrations..."
      system("bundle exec rake db:migrate")
    else
      puts "All migrations are up"
    end

    puts "Setup successfully terminated"
    # :nocov:
  end

  namespace :k8s do
    # This task is used to install your decidim-app to the latest version
    # Meant to be used in a CI/CD pipeline or a k8s job/operator
    # You can add your own customizations here
    desc "Install decidim-app"
    task install: :environment do
      puts "Running db:migrate"
      Rake::Task["db:migrate"].invoke
    end

    # This task is used to upgrade your decidim-app to the latest version
    # Meant to be used in a CI/CD pipeline or a k8s job/operator
    # You can add your own customizations here
    desc "Upgrade decidim-app"
    task upgrade: :environment do
      puts "Running db:migrate"
      Rake::Task["db:migrate"].invoke
    end

    desc "usage: bundle exec rails k8s:dump_db"
    task dump_db: :environment do
      DecidimApp::K8s::ConfigurationExporter.dump_db
    end

    desc "usage: bundle exec rails k8s:export_configuration IMAGE=<docker_image_ref>"
    task export_configuration: :environment do
      image = ENV.fetch("IMAGE", nil)
      raise "You must specify a docker image, usage: bundle exec rails k8s:export_configuration IMAGE=<image_ref>" if image.blank?

      DecidimApp::K8s::ConfigurationExporter.export!(image)
    end

    desc "Create install or reload install with path='path/to/external_install_configuration.yml'"
    task external_install_or_reload: :environment do
      raise "You must specify a path to an external install configuration, path='path/to/external_install_configuration.yml'" if ENV["path"].blank? || !File.exist?(ENV.fetch(
                                                                                                                                                                      "path", nil
                                                                                                                                                                    ))

      DecidimApp::K8s::Manager.run(ENV.fetch("path", nil))
    end
  end
end
