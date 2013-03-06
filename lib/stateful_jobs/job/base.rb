module StatefulJobs
  module Job

    class Base

      attr_reader :model

      def initialize m
        @model = m
      end

      def self.perform m
        self.new(m).perform
      end

      def perform
      end

    end

  end
end