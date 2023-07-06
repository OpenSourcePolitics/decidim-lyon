# frozen_string_literal: true

require "spec_helper"

describe "rake decidim_app:k8s:external_install_or_reload", type: :task do
<<<<<<< HEAD
  let(:path) { Rails.root.join("spec/fixtures/k8s_configuration_example.yml") }

=======
>>>>>>> 28a5c60 (Create organization, system admin and admin from YAML (#339))
  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

<<<<<<< HEAD
  it "calls the manager service" do
    with_modified_env path: path.to_s do
      expect(DecidimApp::K8s::Manager).to receive(:run).with(path.to_s)
=======
  it "calls db:migrate" do
    with_modified_env path: "dummy_path" do
      expect(DecidimApp::K8s::Manager).to receive(:run).with("dummy_path")
>>>>>>> 28a5c60 (Create organization, system admin and admin from YAML (#339))

      task.execute
    end
  end
<<<<<<< HEAD

  context "when path is not specified" do
    it "raises an error" do
      with_modified_env path: nil do
        expect { task.execute }.to raise_error "You must specify a path to an external install configuration, path='path/to/external_install_configuration.yml'"
      end
    end
  end

  context "when path is specified but file does not exist" do
    it "raises an error" do
      with_modified_env path: "dummy_path" do
        expect { task.execute }.to raise_error "You must specify a path to an external install configuration, path='path/to/external_install_configuration.yml'"
      end
    end
  end
=======
>>>>>>> 28a5c60 (Create organization, system admin and admin from YAML (#339))
end
