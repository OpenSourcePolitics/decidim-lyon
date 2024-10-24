# frozen_string_literal: true

require "spec_helper"

describe "rake decidim:set_decrypted_private_body", type: :task do
  let(:task) { Rake::Task["decidim:set_decrypted_private_body"] }
  let!(:extra_fields) { create(:awesome_proposal_extra_fields, proposal: create(:extended_proposal)) }

  before do
    extra_fields.private_body = { "en" => '<xml><dl><dt name="something">Something</dt></dl></xml>' }
    extra_fields.save!
  end

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "prints nothing if no extra_fields to update" do
    expect { task.execute }.not_to output("\"Extra fields to update: 1\"\n\"Extra fields updated: 1\"\n").to_stdout
  end

  it "sets the decrypted body correctly" do
    # we need an empty decrypted_private_body to test if the task will update it well
    extra_fields.update_columns(decrypted_private_body: nil)
    expect(extra_fields.decrypted_private_body).to be_nil
    expect { task.execute }.to output("\"Extra fields to update: 1\"\n\"Extra fields updated: 1\"\n").to_stdout
    expect(extra_fields.reload.decrypted_private_body).to eq('{"en"=>"<xml><dl><dt name=\"something\">Something</dt></dl></xml>"}')
  end
end
