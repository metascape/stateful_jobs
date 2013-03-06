class CreateTestRuns < ActiveRecord::Migration
  def change
    create_table :test_runs do |t|
      t.string :current_job
      t.string :current_state

      t.timestamps
    end
  end
end
