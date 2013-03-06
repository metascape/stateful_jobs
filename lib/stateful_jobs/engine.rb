require 'stateful_jobs/view_helpers'
require 'stateful_jobs/routing.rb'

module StatefulJobs
  class Engine < Rails::Engine
    initializer "stateful_jobs.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
      ActionDispatch::Routing::Mapper.send :include, Routing::Mapper
    end
  end
end