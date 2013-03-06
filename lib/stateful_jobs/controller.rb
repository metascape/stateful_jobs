module StatefulJobs

  module Controller
    extend ActiveSupport::Concern

    included do
      class << self
        attr_accessor :stateful_jobs_class, :stateful_jobs_options
      end
    end

    module ClassMethods
      def stateful_jobs klass, options = {}
        self.stateful_jobs_class = klass.to_s.camelcase.constantize
        self.stateful_jobs_options = options

        if options[:action]
          define_method options[:action] do
          end
        else
          if self.stateful_jobs_class.stateful_jobs.is_a? Hash
            self.stateful_jobs_class.stateful_jobs.keys.each do |job|
              define_method job do
              end
            end
          end
        end
      end
    end

    def state
      render json: stateful_jobs_class.where(id: params[:id]).limit(1).select('current_job, current_state').first.to_json
    end

    def stateful_jobs_class
      self.class.stateful_jobs_class
    end

  end

end