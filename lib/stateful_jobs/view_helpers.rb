module StatefulJobs
  module ViewHelpers

    def stateful_job name, model, html_element = :span, options = {}, &block
      path = send "#{name}_path"

      js_options = {}
      [:interval, :ajax, :action, :final].each do |option|
        js_options[option] = options.delete(option) if options[option]
      end

      options[:data] = {'id' => model.id, 'current-job' => model.current_job, 'current-state' => model.current_state}
      options[:id] = "#{name}_#{model.id}" unless options[:id]

      html = if block_given?
        content_tag html_element, options do
          capture &block
        end
      else
        content_tag html_element, '', options
      end

      js = javascript_tag "$('##{options[:id]}').statefulJobs('#{path}', #{js_options.to_json});"

      html + js
    end

  end
end