# frozen_string_literal: true

require "spec_helper"

describe DecidimApp::RackAttack::Fail2ban do
<<<<<<< HEAD
  describe ".enabled?" do
=======
  describe "#enabled?" do
>>>>>>> 1ed0296 (Refactor Rack Attack configuration (#312))
    it "returns true" do
      expect(described_class).to be_enabled
    end

    context "when rails secret is not set" do
      before do
        allow(Rails.application.secrets).to receive(:dig).with(:decidim, :rack_attack, :fail2ban, :enabled).and_return(0)
      end

      it "returns false" do
        expect(described_class).not_to be_enabled
      end
    end
  end

<<<<<<< HEAD
  describe ".unauthorized_path?" do
=======
  describe "#unauthorized_path?" do
>>>>>>> 1ed0296 (Refactor Rack Attack configuration (#312))
    let(:path) { "SELECT" }

    it "returns true" do
      expect(described_class).to be_unauthorized_path(path)
    end

    context "when path is not in list" do
      let(:path) { "/users/sign_in" }

      it "returns false" do
        expect(described_class).not_to be_unauthorized_path(path)
      end
    end
  end
end
