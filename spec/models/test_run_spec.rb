require 'spec_helper'

class TestJob < StatefulJobs::Job::Base
end

describe TestRun do

  describe 'model' do
    it 'implements the stateful_job class method' do
      TestRun.methods.should include(:stateful_job)
    end

    it 'implements the stateful_job_for class method' do
      TestRun.methods.should include(:stateful_job_for)
    end
  end

  describe '#stateful_job' do
    before :each do
      TestRun.stateful_jobs = {}
    end

    context 'with block given' do
      it 'adds the job to its jobs hash' do
        TestRun.stateful_job :test_job do
        end

        TestRun.stateful_jobs.should have_key(:test_job)
        TestRun.stateful_jobs[:test_job].should be_a(Proc)
      end

      it 'defines a ! method for enqueuing the job' do
        TestRun.instance_methods.should include(:test_job!)
      end
    end

    context 'with block given' do
      it 'adds the job to its jobs hash' do
        TestRun.stateful_job :test_job, TestJob

        TestRun.stateful_jobs.should have_key(:test_job)
        TestRun.stateful_jobs[:test_job].should eql(TestJob)
      end

      it 'defines a ! method for enqueuing the job' do
        TestRun.instance_methods.should include(:test_job!)
      end
    end
  end

  describe '#stateful_job_for' do
    before :each do
      TestRun.stateful_jobs = {}

      TestRun.stateful_job :test_job, TestJob
    end

    it 'returns the job fo given key' do
      TestRun.stateful_job_for(:test_job).should eql(TestJob)
    end
  end

  describe 'enqueuing jobs' do
    before :each do
      TestRun.stateful_jobs = {}
      TestRun.stateful_job :test_job, TestJob

      @test_run = TestRun.create
    end

    it 'enqueues the job' do
      StatefulJobs::Job.should_receive(:enqueue).with(@test_run, :test_job)

      @test_run.test_job!
    end
  end
end