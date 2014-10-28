module GoApiClient
  module Parsers
    class ScheduledJob < GoApiClient::Parsers::Helper

      class << self
        def parse(root)
          environment = root.xpath('./environment').first.content if root.xpath('./environment').first
          resources = root.xpath('./resources/resource').collect do |element|
            element.content
          end if root.xpath('./resources/resource')
          environment_variables = root.xpath('./environmentVariables/variable').collect do |element|
            {:name => element.attributes['name'].value, :value => element.content}
          end if root.xpath('./environmentVariables/variable')
          GoApiClient::Domain::ScheduledJob.new(
              {
                  :name => root.attributes['name'].value,
                  :id => root.attributes['id'].value.to_i,
                  :self_uri => href_from(root.xpath("./link[@rel='self']")),
                  :build_locator => root.xpath('./buildLocator').first.content,
                  :environment => environment,
                  :resources => resources,
                  :environment_variables => environment_variables
              })
        end
      end
    end
  end
end
