module GoApiClient
  module Domain
    module Config
      class Pipeline < GoApiClient::AttributeHelper

        attr_accessor :name, :label_template, :locked, :template, :timer
        attr_accessor :parsed_params, :parsed_env_vars, :parsed_stages, :parsed_template

        def initialize(attributes={})
          super(attributes)
        end
      end
    end
  end
end
