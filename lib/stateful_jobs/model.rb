module StatefulJobs

  module Model

    extend ActiveSupport::Concern

    included do
      class << self
        attr_accessor :stateful_jobs
      end
    end

    def stateful_jobs
      self.class.stateful_jobs.keys
    end

    module ClassMethods
      def stateful_job name, klass = nil, &block
        @stateful_jobs ||= {}
        name = name.to_sym

        @stateful_jobs[name] = (block_given?)? block : klass

        define_method "#{name}!" do
          StatefulJobs::Job.enqueue self, name
        end
      end

      def stateful_job_for j
        @stateful_jobs[j.to_sym]
      end
    end

  end

end