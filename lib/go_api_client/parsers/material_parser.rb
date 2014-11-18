require 'time'

module GoApiClient
  module Parsers
    class Material
      class << self

        def parse(root)
          url = root.attributes['url'].value if root.attributes['url']
          branch = root.attributes['url'].value if root.attributes['branch']
          pipeline_name = root.attributes['pipelineName'].value if root.attributes['pipelineName']
          stage_name = root.attributes['stageName'].value if root.attributes['stageName']
          GoApiClient::Domain::Material.new(
              {
                  :uri => root.attributes['materialUri'].value,
                  :type => root.attributes['type'].value,
                  :url => url,
                  :branch => branch,
                  :pipeline_name => pipeline_name,
                  :stage_name => stage_name,
                  :parsed_changesets => root.xpath('./modifications/changeset').collect do |element|
                    GoApiClient::Parsers::Changeset.parse(element)
                  end
              })
        end
      end
    end
  end
end
