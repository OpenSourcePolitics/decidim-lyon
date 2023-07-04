# frozen_string_literal: true

require "spec_helper"

describe "rake decidim_app:k8s:export_configuration", type: :task do
  let(:image) { "dummy-image" }
<<<<<<< HEAD
=======
  let(:enable_sync) { true }
>>>>>>> 0ace9b5 (Move to K8s namespace)

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "invokes the configuration exporter" do
<<<<<<< HEAD
    with_modified_env IMAGE: image do
      expect(DecidimApp::K8s::ConfigurationExporter).to receive(:export!).with(image).and_return(true)
=======
<<<<<<<< HEAD:spec/lib/tasks/k8s/export_configuration_tasks_spec.rb
    with_modified_env IMAGE: image, ENABLE_SYNC: enable_sync.to_s do
      expect(K8sConfigurationExporter).to receive(:export!).with(image, enable_sync).and_return(true)
========
    with_modified_env IMAGE: image do
      expect(K8s::ConfigurationExporter).to receive(:export!).with(image).and_return(true)
>>>>>>>> 0ace9b5 (Move to K8s namespace):spec/lib/tasks/decidim_app/k8s/export_configuration_tasks_spec.rb
>>>>>>> 0ace9b5 (Move to K8s namespace)

      task.execute
    end
  end
end
