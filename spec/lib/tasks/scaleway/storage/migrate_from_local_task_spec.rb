# frozen_string_literal: true

require "spec_helper"

describe "rake scaleway:storage:migrate_from_local", type: :task do
  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

<<<<<<< HEAD
  it "invokes the migrator" do
=======
  it "invokes the admin creator" do
>>>>>>> c64ef27 (Refactor migrations tools (#329))
    expect(ActiveStorage::Migrator).to receive(:migrate!).with(:local, :scaleway).and_return(true)

    task.execute
  end
end
