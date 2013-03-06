class TestRun < ActiveRecord::Base

  include StatefulJobs::Model

  stateful_job :load do |test_run|
  end

  stateful_job :execute, ExecuteJob

end