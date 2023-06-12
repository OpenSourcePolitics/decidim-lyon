# Overrides
## Delete newsletter checkbox
* `app/forms/decidim/registration_form.rb:13`
* `app/views/decidim/devise/registrations/new.html.erb:79`
* `app/assets/javascripts/decidim/user_registrations.js`
* `app/commands/decidim/create_registration.rb`
* `app/views/decidim/devise/registrations/new.html.erb`
* `app/views/decidim/notifications_settings/show.html.erb`
## Load decidim-awesome assets only if dependency is present
* `app/views/layouts/decidim/_head.html.erb:33`
## Fix geocoded proposals
* `app/controllers/decidim/proposals/proposals_controller.rb`
* `spec/controllers/decidim/proposals/proposals_controller_spec.rb`
## Fix cache on Hero Cell
* `lib/extends/cells/decidim/content_blocks/hero_cell_extends.rb:13`
##  Fix meetings registration serializer
* `app/serializers/decidim/meetings/registration_serializer.rb`
## Fix UserAnswersSerializer for CSV exports
* `lib/decidim/forms/user_answers_serializer.rb`
## 28c8d74 - Add basic tests to reference package (#1), 2021-07-26
* `lib/extends/commands/decidim/admin/create_participatory_space_private_user_extends.rb`
* `lib/extends/commands/decidim/admin/impersonate_user_extends.rb`
##  cd5c2cc - Backport fix/user answers serializer (#11), 2021-09-30
* `lib/decidim/forms/user_answers_serializer.rb`
## Fix metrics issue in admin dashboard
 - **app/stylesheets/decidim/vizzs/_areachart.scss**
```scss
    .area{
        fill: rgba($primary, .2);;
    }
```
## Disable proposals cells caching
 - **app/cells/decidim/proposals/proposal_m_cell.rb**
```ruby
      # Potential backport at https://github.com/decidim/decidim/pull/8566/files
      def perform_caching?
        false
      end
```
* `app/forms/decidim/proposals/proposal_form.rb`
7b49261 - [Feature] - customize proposal form (#10), 2022-02-18

* `app/views/decidim/devise/shared/_omniauth_buttons.html.erb`
3f99373 - Add SSO logo to omniauth button, 2022-03-02

* `app/views/decidim/proposals/collaborative_drafts/_edit_form_fields.html.erb`
7b49261 - [Feature] - customize proposal form (#10), 2022-02-18

* `app/views/decidim/proposals/proposals/_edit_form_fields.html.erb`
7b49261 - [Feature] - customize proposal form (#10), 2022-02-18

* `app/assets/images/decidim/gl_connect_sso.png`
3f99373 - Add SSO logo to omniauth button, 2022-03-02

* `app/assets/javascripts/decidim/proposals/add_proposal.js`
7b49261 - [Feature] - customize proposal form (#10), 2022-02-18

* `app/assets/fonts/decidim/MinionPro/MinionPro-Bold.ttf`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-MediumIt.eot`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-Regular.woff`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-Regular.woff2`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-Bold.eot`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-MediumIt.ttf`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-Regular.svg`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-Regular.eot`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-Bold.woff`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-Bold.svg`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-Regular.ttf`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-MediumIt.woff2`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-Bold.woff2`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-MediumIt.woff`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/fonts/decidim/MinionPro/MinionPro-MediumIt.svg`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/assets/stylesheets/decidim/vizzs/_areachart.scss`
ba7313e - Fix metrics in admin dashboard, 2021-12-02

* `app/assets/stylesheets/_fontface.scss`
b5f0966 - Add fonts and import fontface.scss (#1), 2021-12-16

* `app/helpers/decidim/backup_helper.rb`
83830be - Add retention service for daily backups (#19), 2021-11-09

* `app/services/decidim/s3_retention_service.rb`
83830be - Add retention service for daily backups (#19), 2021-11-09

* `config/initializers/extends.rb`
0088323 - backport/8679 (#13), 2022-02-24

* `config/initializers/omniauth_publik.rb`
95e4c7e - [SSO] Enable publik (#2), 2022-02-07

* `config/initializers/ransack.rb`
550ccbf - Don't cast integers to booleans (#5), 2022-02-15

* `lib/extends/serializers/proposals/proposals_serializer_extends.rb`
0088323 - backport/8679 (#13), 2022-02-24

* `lib/tasks/restore_dump.rake`
705e0ad - Run rubocop, 2021-12-01

* `app/views/decidim/devise/shared/_omniauth_buttons_mini.html.erb`
6790cdd - Update omniauth buttons mini, 2022-03-02

