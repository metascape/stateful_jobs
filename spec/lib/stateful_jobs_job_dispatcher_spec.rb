require 'spec_helper'

class TestJob < StatefulJobs::Job::Base
end

describe StatefulJobs::Job::Dispatcher do

  describe '#perform' do
    before :each do
      @test_run = TestRun.create
      TestRun.stub(:find).and_return(@test_run)
    end

    context 'with job class' do
      before :each do
        TestRun.stateful_jobs = {}
        TestRun.stateful_job :test_job, TestJob
      end

      it 'calls the jobs perform method' do
        TestJob.should_receive(:perform).with(@test_run)

        StatefulJobs::Job::Dispatcher.perform 'TestRun', @test_run.id, 'test_job'
      end

      it 'sets the current job' do
        StatefulJobs::Job::Dispatcher.perform 'TestRun', @test_run.id, 'test_job'

        @test_run.reload
        @test_run.current_job.should eql('test_job')
      end

      it 'sets the done state on successful jobs' do
        TestJob.should_receive(:perform).with(@test_run).and_return true

        StatefulJobs::Job::Dispatcher.perform 'TestRun', @test_run.id, 'test_job'

        TestRun.unstub(:find)
        @test_run.reload

        @test_run.current_state.should eql('done')
      end

      it 'sets the failure state on non successful jobs' do
        TestJob.should_receive(:perform).with(@test_run).and_return false

        StatefulJobs::Job::Dispatcher.perform 'TestRun', @test_run.id, 'test_job'

        TestRun.unstub(:find)
        @test_run.reload

        @test_run.current_state.should eql('failed')
      end

      it 'sets the error state when exception was thrown' do
        TestJob.should_receive(:perform).with(@test_run).and_raise Exception

        expect {
          StatefulJobs::Job::Dispatcher.perform 'TestRun', @test_run.id, 'test_job'
        }.to raise_error

        TestRun.unstub(:find)
        @test_run.reload

        @test_run.current_state.should eql('error')
      end
    end

    context 'with job proc' do
      before :each do
        TestRun.stateful_jobs = {}
        TestRun.stateful_job :test_job do
        end
      end

      it 'calls the jobs proc' do
        TestRun.stateful_jobs[:test_job].should_receive(:call).with(@test_run)

        StatefulJobs::Job::Dispatcher.perform 'TestRun', @test_run.id, 'test_job'
      end

      it 'sets the current job' do
        StatefulJobs::Job::Dispatcher.perform 'TestRun', @test_run.id, 'test_job'

        @test_run.reload
        @test_run.current_job.should eql('test_job')
      end

      it 'sets the done state on successful jobs' do
        TestRun.stateful_jobs[:test_job].should_receive(:call).with(@test_run).and_return true

        StatefulJobs::Job::Dispatcher.perform 'TestRun', @test_run.id, 'test_job'

        TestRun.unstub(:find)
        @test_run.reload

        @test_run.current_state.should eql('done')
      end

      it 'sets the failure state on non successful jobs' do
        TestRun.stateful_jobs[:test_job].should_receive(:call).with(@test_run).and_return false

        StatefulJobs::Job::Dispatcher.perform 'TestRun', @test_run.id, 'test_job'

        TestRun.unstub(:find)
        @test_run.reload

        @test_run.current_state.should eql('failed')
      end

      it 'sets the error state when exception was thrown' do
        TestRun.stateful_jobs[:test_job].should_receive(:call).with(@test_run).and_raise Exception

        expect {
          StatefulJobs::Job::Dispatcher.perform 'TestRun', @test_run.id, 'test_job'
        }.to raise_error

        TestRun.unstub(:find)
        @test_run.reload

        @test_run.current_state.should eql('error')
      end
    end
  end

end