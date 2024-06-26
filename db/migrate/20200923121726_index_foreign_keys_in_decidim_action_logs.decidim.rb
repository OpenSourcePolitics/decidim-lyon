# frozen_string_literal: true

# This migration comes from decidim (originally 20200320105904)

class IndexForeignKeysInDecidimActionLogs < ActiveRecord::Migration[5.2]
  def change
    add_index :decidim_action_logs, :decidim_area_id
    add_index :decidim_action_logs, :decidim_scope_id
    add_index :decidim_action_logs, :version_id unless index_exists?(:decidim_action_logs, :version_id)
  end
end
