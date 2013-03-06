require 'spec_helper'

describe TestRunsController do

  describe 'controller' do
    it 'implements the stateful_jobs class method' do
      TestRunsController.methods.should include(:stateful_jobs)
    end

    it 'implements the state action' do
      TestRunsController.instance_methods.should include(:state)
    end

    it 'implements the load action' do
      TestRunsController.instance_methods.should include(:load)
    end

    it 'implements the execute action' do
      TestRunsController.instance_methods.should include(:execute)
    end
  end

  describe '#stateful_jobs_class' do
    it 'returns the curren model, implementing the jobs' do
      TestRunsController.stateful_jobs_class.should eql(TestRun)
    end
  end

  describe 'GET state' do
    before :each do
      @test_run = TestRun.create do |tr|
        tr.current_job = 'load'
        tr.current_state = 'running'
      end
    end

    it 'returns current job and state as json' do
      get :state, id: @test_run.to_param

      json = JSON.parse response.body

      json['current_job'].should eql('load')
      json['current_state'].should eql('running')
    end
  end

end