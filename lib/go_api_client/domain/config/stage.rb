module GoApiClient
  module Domain
    module Config
      class Stage < GoApiClient::AttributeHelper

        attr_accessor :name, :fetch_materials, :approval, :clean_working_dir
        attr_accessor :parsed_jobs, :parsed_env_vars

        def initialize(attributes={})
          super(attributes)
        end
      end
    end
  end
end
