module StatefulJobs
  module Job

    def self.enqueue model, job
      Resque.enqueue Dispatcher, model.class.to_s, model.id, job
    end

  end
end