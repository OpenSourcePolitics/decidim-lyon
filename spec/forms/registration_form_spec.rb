# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe RegistrationForm do
    subject do
      described_class.from_params(
        attributes
      ).with_context(
        context
      )
    end

    let(:organization) { create(:organization) }
    let(:name) { "User" }
    let(:nickname) { "justme" }
    let(:email) { "user@example.org" }
    let(:password) { "S4CGQ9AM4ttJdPKS" }
    let(:password_confirmation) { password }
    let(:tos_agreement) { "1" }

    let(:attributes) do
      {
        name: name,
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        tos_agreement: tos_agreement
      }
    end

    let(:context) do
      {
        current_organization: organization
      }
    end

    context "when everything is OK" do
      it { is_expected.to be_valid }
    end

    context "when the email is a disposable account" do
      let(:email) { "user@mailbox92.biz" }

      it { is_expected.to be_invalid }
    end

    context "when the name is not present" do
      let(:name) { nil }

      it { is_expected.to be_invalid }
    end

    context "when the email is not present" do
      let(:email) { nil }

      it { is_expected.to be_invalid }
    end

    context "when the email already exists" do
      let!(:user) { create(:user, organization: organization, email: email) }

      it { is_expected.to be_invalid }

      context "and is pending to accept the invitation" do
        let!(:user) { create(:user, organization: organization, email: email, invitation_token: "foo", invitation_accepted_at: nil) }

        it { is_expected.to be_invalid }
      end
    end

    context "when the password is not present" do
      let(:password) { nil }

      it { is_expected.to be_invalid }
    end

    context "when the password is weak" do
      let(:password) { "aaaabbbbcccc" }

      it { is_expected.to be_invalid }
    end

    context "when the password confirmation is not present" do
      let(:password_confirmation) { nil }

      it { is_expected.to be_invalid }
    end

    context "when the password confirmation is different from password" do
      let(:password_confirmation) { "invalid" }

      it { is_expected.to be_invalid }
    end

    context "when the tos_agreement is not accepted" do
      let(:tos_agreement) { "0" }

      it { is_expected.to be_invalid }
    end

    context "when hide_nickname is active" do
      it { is_expected.to be_valid }

      it "generates a nickname" do
        expect(subject.nickname).to eq("user")
      end
    end

    context "when hide_nickname is inactive" do
      before do
        allow(Decidim::FriendlySignup).to receive(:hide_nickname).and_return(false)
      end

      it { is_expected.to be_invalid }

      it "does not generate a nickname" do
        expect(subject.nickname).to be_blank
      end

      context "when everything is OK" do
        let(:attributes) do
          {
            name: name,
            nickname: nickname,
            email: email,
            password: password,
            password_confirmation: password_confirmation,
            tos_agreement: tos_agreement
          }
        end

        it { is_expected.to be_valid }

        it "uses params nickname" do
          expect(subject.nickname).to eq("justme")
        end
      end
    end
  end
end
