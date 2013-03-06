class TestRunsController < ApplicationController

  include StatefulJobs::Controller

  stateful_jobs :test_run

end