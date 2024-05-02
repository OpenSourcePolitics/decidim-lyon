# frozen_string_literal: true

require "spec_helper"

describe "Account", type: :system do
  let(:user) { create(:user, :confirmed, password: password, password_confirmation: password) }
  let(:password) { "dqCFgjfDbC7dPbrv" }
  let(:organization) { user.organization }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  describe "navigation" do
    it "shows the account form when clicking on the menu" do
      visit decidim.root_path

      within ".topbar__user__logged" do
        find("a", text: user.name).click
        find("a", text: "My account").click
      end

      expect(page).to have_css("form.edit_user")
    end
  end

  context "when on the account page" do
    before do
      visit decidim.account_path
    end

    describe "update avatar" do
      it "can update avatar" do
        dynamically_attach_file(:user_avatar, Decidim::Dev.asset("avatar.jpg"), remove_before: true)

        within "form.edit_user" do
          find("*[type=submit]").click
        end

        expect(page).to have_css(".flash.success")
      end

      it "shows error when image is too big" do
        find("#user_avatar_button").click

        within ".upload-modal" do
          find(".remove-upload-item").click
          input_element = find("input[type='file']", visible: :all)
          input_element.attach_file(Decidim::Dev.asset("5000x5000.png"))

          expect(page).to have_content("File resolution is too large", count: 1)
          expect(page).to have_css(".upload-errors .form-error", count: 1)
        end

        expect(page).to have_content("File resolution is too large", count: 1)
      end
    end

    describe "updating personal data" do
      let!(:encrypted_password) { user.encrypted_password }

      it "updates the user's data" do
        within "form.edit_user" do
          select "Français", from: :user_locale
          fill_in :user_name, with: "Nikola Tesla"
          fill_in :user_personal_url, with: "https://example.org"
          fill_in :user_about, with: "A Serbian-American inventor, electrical engineer, mechanical engineer, physicist, and futurist."
          find("*[type=submit]").click
        end

        within_flash_messages do
          expect(page).to have_content("successfully")
        end

        within ".title-bar" do
          expect(page).to have_content("Nikola Tesla")
        end

        user.reload

        within ".topbar__user__logged" do
          find("a", text: user.name).click
          find("a", text: "Mon profil public").click
        end

        expect(page).to have_content("example.org")
        expect(page).to have_content("Serbian-American")

        # The user's password should not change when they did not update it
        expect(user.reload.encrypted_password).to eq(encrypted_password)
      end
    end

    describe "updating the password" do
      context "when password and confirmation match" do
        it "updates the password successfully" do
          within "form.edit_user" do
            page.find(".change-password").click

            fill_in :user_password, with: "sekritpass123"

            find("*[type=submit]").click
          end

          within_flash_messages do
            expect(page).to have_content("successfully")
          end

          expect(user.reload.valid_password?("sekritpass123")).to be(true)
        end
      end
    end

    context "when updating the email" do
      let(:pending_email) { "foo@bar.com" }

      before do
        within "form.edit_user" do
          fill_in :user_email, with: pending_email

          perform_enqueued_jobs { find("*[type=submit]").click }
        end

        within_flash_messages do
          expect(page).to have_content("You'll receive an email to confirm your new email address")
        end
      end

      after do
        clear_enqueued_jobs
      end

      it "tells user to confirm new email" do
        expect(page).to have_content("Email change verification")
        expect(page).to have_selector("#user_email[disabled='disabled']")
        expect(page).to have_content("We've sent an email to #{pending_email} to verify your new email address")
      end

      it "resend confirmation" do
        within "#email-change-pending" do
          click_link "Send again"
        end
        expect(page).to have_content("Confirmation email resent successfully to #{pending_email}")
        perform_enqueued_jobs
        perform_enqueued_jobs

        expect(emails.count).to eq(2)
        visit last_email_link
        expect(page).to have_content("Your email address has been successfully confirmed")
      end
    end

    context "when on the interests page" do
      before do
        visit decidim.user_interests_path
      end

      it "doesn't find any scopes" do
        expect(page).to have_content("My interests")
        expect(page).to have_content("This organization doesn't have any scope yet")
      end

      context "when scopes are defined" do
        let!(:scopes) { create_list(:scope, 3, organization: organization) }
        let!(:subscopes) { create_list(:subscope, 3, parent: scopes.first) }

        before do
          visit decidim.user_interests_path
        end

        it "display translated scope name" do
          label_field = "label[for='user_scopes_#{scopes.first.id}_checked']"
          expect(page).to have_content("My interests")
          expect(find("#{label_field} > span.switch-label").text).to eq(translated(scopes.first.name))
        end

        it "allows to choose interests" do
          label_field = "label[for='user_scopes_#{scopes.first.id}_checked']"
          expect(page).to have_content("My interests")
          find(label_field).click
          click_button "Update my interests"

          within_flash_messages do
            expect(page).to have_content("Your interests have been successfully updated.")
          end
        end
      end
    end

    context "when on the delete my account page" do
      before do
        visit decidim.delete_account_path
      end

      it "the user can delete their account" do
        fill_in :delete_user_delete_account_delete_reason, with: "I just want to delete my account"

        click_button "Delete my account"

        click_button "Yes, I want to delete my account"

        within_flash_messages do
          expect(page).to have_content("successfully")
        end

        find(".sign-in-link").click

        within ".new_user" do
          fill_in :session_user_email, with: user.email
          fill_in :session_user_password, with: password
          find("*[type=submit]").click
        end

        expect(page).to have_no_content("Signed in successfully")
        expect(page).to have_no_content(user.name)
      end
    end
  end
end
