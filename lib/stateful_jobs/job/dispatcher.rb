module StatefulJobs
  module Job

    class Dispatcher
      @queue = :stateful_jobs

      def self.perform model, id, job_name
        begin
          model_class = const_get(model)
          model = model_class.find id

          job = model_class.stateful_job_for(job_name)

          model.current_job = job_name
          model.current_state = 'running'
          model.save validate: false

          if job.is_a?(Class)? job.perform(model) : job.call(model)
            model_class.where(id: id).update_all current_state: 'done', updated_at: Time.now
          else
            model_class.where(id: id).update_all current_state: 'failed', updated_at: Time.now
          end
        rescue Exception => e
          model_class.where(id: id).update_all current_state: 'error', updated_at: Time.now
          raise e
        end
      end
    end

  end
end