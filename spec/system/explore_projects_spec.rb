# frozen_string_literal: true

require "spec_helper"

describe "Explore projects", :slow, type: :system do
  include_context "with a component"
  let(:manifest_name) { "budgets" }
  let(:budget) { create :budget, component: component }
  let(:projects_count) { 5 }
  let!(:projects) do
    create_list(:project, projects_count, budget: budget)
  end
  let!(:project) { projects.first }
  let(:categories) { create_list(:category, 3, participatory_space: component.participatory_space) }

  describe "index" do
    it "shows all resources for the given component" do
      visit_budget
      within "#projects" do
        expect(page).to have_selector(".budget-list__item", count: projects_count)
      end

      projects.each do |project|
        expect(page).to have_content(translated(project.title))
      end
    end

    context "when filtering" do
      it "allows searching by text" do
        visit_budget
        within ".filters__search" do
          fill_in "filter[search_text_cont]", with: translated(project.title)

          find(".button").click
        end

        within "#projects" do
          expect(page).to have_css(".budget-list__item", count: 1)
          expect(page).to have_content(translated(project.title))
        end
      end

      it "allows filtering by scope" do
        scope = create(:scope, organization: organization)
        project.scope = scope
        project.save

        visit_budget

        within ".with_any_scope_check_boxes_tree_filter" do
          uncheck "All"
          check translated(scope.name)
        end

        within "#projects" do
          expect(page).to have_css(".budget-list__item", count: 1)
          expect(page).to have_content(translated(project.title))
        end
      end

      it "allows filtering by category" do
        category = categories.first
        project.category = category
        project.save

        visit_budget

        within ".with_any_category_check_boxes_tree_filter" do
          uncheck "All"
          check translated(category.name)
        end

        within "#projects" do
          expect(page).to have_css(".budget-list__item", count: 1)
          expect(page).to have_content(translated(project.title))
        end
      end

      context "when filtering by category and changing pages" do
        let!(:projects_count) { 10 }
        let!(:categories) { create_list(:category, 2, participatory_space: component.participatory_space) }

        it "keeps the order of the projects displayed on the pages" do
          component.update!(settings: { projects_per_page: 3 })
          first_cate = categories.first
          sec_cate = categories.last
          projects.each_with_index do |project, index|
            index.even? ? project.category = first_cate : project.category = sec_cate
            project.save
          end

          visit_budget

          within ".with_any_category_check_boxes_tree_filter" do
            uncheck "All"
            uncheck translated(first_cate.name)
          end

          within "#projects" do
            expect(page).to have_css(".budget-list__item", count: 3)
          end

          budget_list = all('div.budget-list__item')
          first_proj = budget_list[0][:id]
          sec_proj = budget_list[1][:id]
          third_proj = budget_list[2][:id]

          within "#projects .pagination" do
            # navigate page 2
            expect(page).to have_content("2")
            page.find("a", text: "2").click
          end

          within "#projects .pagination" do
            # navigate back page 1
            page.find("a", text: "1").click
          end

          # check that the projects are displayed in the same order on page one
          new_budget_list = all('div.budget-list__item')
          expect(new_budget_list[0][:id]).to eq(first_proj)
          expect(new_budget_list[1][:id]).to eq(sec_proj)
          expect(new_budget_list[2][:id]).to eq(third_proj)
        end
      end

      context "and votes are finished" do
        let!(:component) do
          create(:budgets_component,
                 :with_voting_finished,
                 manifest: manifest,
                 participatory_space: participatory_process)
        end

        it "allows filtering by status" do
          project.selected_at = Time.current
          project.save

          visit_budget

          within "#projects" do
            expect(page).to have_css(".budget-list__item", count: 1)
            expect(page).to have_content(translated(project.title))
          end
        end
      end
    end

    context "when directly accessing from URL with an invalid budget id" do
      it_behaves_like "a 404 page" do
        let(:target_path) { decidim_budgets.budget_projects_path(99_999_999) }
      end
    end

    context "when directly accessing from URL with an invalid project id" do
      it_behaves_like "a 404 page" do
        let(:target_path) { decidim_budgets.budget_project_path(budget, 99_999_999) }
      end
    end
  end

  private

  def decidim_budgets
    Decidim::EngineRouter.main_proxy(component)
  end

  def visit_budget
    page.visit decidim_budgets.budget_projects_path(budget)
  end
end
