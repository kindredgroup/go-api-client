module GoApiClient
  module Domain
    class Project < GoApiClient::AttributeHelper

      attr_accessor :name, :activity, :last_build_status, :last_build_label, :last_build_time, :web_uri
      attr_accessor :parsed_messages, :parsed_pipeline_name, :parsed_stage_name, :parsed_job_name

      def initialize(attributes)
        super(attributes)
      end
    end
  end
end

