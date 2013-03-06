require 'spec_helper'

class TestJob < StatefulJobs::Job::Base
end

describe StatefulJobs::Job do

  describe '#enqueue' do
    before :each do
      TestRun.stateful_jobs = {}
      TestRun.stateful_job :test_job, TestJob

      @test_run = TestRun.create
    end

    it 'enqueues the Dispatcher with given job on resque' do
      Resque.should_receive(:enqueue).with(StatefulJobs::Job::Dispatcher, 'TestRun', @test_run.id, :test_job)

      StatefulJobs::Job.enqueue @test_run, :test_job
    end
  end

end