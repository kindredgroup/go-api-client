module GoApiClient
  module Domain
    module Config
      class Job < GoApiClient::AttributeHelper

        attr_accessor :name
        attr_accessor :parsed_tasks, :parsed_resources, :parsed_artifacts, :parsed_test_artifacts, :parsed_tabs

        def initialize(attributes={})
          super(attributes)
        end
      end
    end
  end
end
