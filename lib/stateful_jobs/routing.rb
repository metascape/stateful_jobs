module StatefulJobs
  module Routing
    module Mapper

      def stateful_jobs_resource *resources, &block
        options = resources.extract_options!.dup

        path_name = resources.first

        if options[:controller]
          controller = "#{options[:controller].camelcase}Controller".constantize
        else
          controller = "#{resources.first.to_s.pluralize.camelcase}Controller".constantize
        end

        create_stateful_jobs_routes path_name, controller

        resources(*resources, &block)
      end

      def stateful_jobs_resources *resources, &block
        options = resources.extract_options!.dup

        path_name = resources.first

        if options[:controller]
          controller = "#{options[:controller].camelcase}Controller".constantize
        else
          controller = "#{resources.first.to_s.camelcase}Controller".constantize
        end

        create_stateful_jobs_routes path_name, controller

        resources(*resources, &block)
      end

      def stateful_jobs controller
        path_name = controller
        controller = "#{controller.to_s.camelcase}Controller".constantize
        create_stateful_jobs_routes path_name, controller
      end

    private

      def create_stateful_jobs_routes path_name, controller
        get "#{path_name}/:id/state", to: "#{path_name}#state", as: "#{path_name}_state".to_sym

        if controller.stateful_jobs_options[:action]
          get "#{path_name}/:id/#{controller.stateful_jobs_options[:action]}", to: "#{path_name}##{controller.stateful_jobs_options[:action]}", as: "#{path_name}_#{stateful_jobs_options[:action]}".to_sym
        else
          controller.stateful_jobs_class.stateful_jobs.keys.each do |job|
            get "#{path_name}/:id/#{job}", to: "#{path_name}##{job}", as: "#{path_name}_#{job}".to_sym
          end
        end
      end

    end
  end
end