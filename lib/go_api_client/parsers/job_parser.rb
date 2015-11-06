require 'time'

module GoApiClient
  module Parsers
    class Job < GoApiClient::Parsers::Helper

      PROPERTIES = {
          :duration => :cruise_job_duration,
          :result => :cruise_job_result,
          :scheduled => :cruise_timestamp_01_scheduled,
          :assigned => :cruise_timestamp_02_assigned,
          :preparing => :cruise_timestamp_03_preparing,
          :building => :cruise_timestamp_04_building,
          :completing => :cruise_timestamp_05_completing,
          :completed => :cruise_timestamp_06_completed,
      }

      class << self
        def parse(root)
          artifacts_uri = root.xpath('./artifacts').first.attributes['baseUri'].value
          attributes = {
              :artifacts_uri => artifacts_uri,
              :self_uri => href_from(root.xpath("./link[@rel='self']")),
              :id => root.xpath('./id').first.content,
              :name => root.attributes['name'].value,
              :state => root.xpath('./state').first.content,
              :parsed_artifacts => root.xpath('./artifacts/artifact').collect do |artifact_element|
                GoApiClient::Parsers::Artifact.parse(artifacts_uri, artifact_element)
              end
          }
          PROPERTIES.each do |variable, property_name|
            property_value = root.xpath("./properties/property[@name='#{property_name}']").first.content rescue nil
            next if property_value.nil? || property_value.empty?
            if property_name =~ /timestamp/
              property_value = Time.parse(property_value).utc
            elsif property_value =~ /^\d+$/
              property_value = property_value.to_i
            end
            attributes = {variable => property_value}.merge(attributes)
          end
          GoApiClient::Domain::Job.new(attributes)
        end
      end
    end
  end
end
