require 'time'

module GoApiClient
  module Parsers
    class Project < GoApiClient::Parsers::Helper
      class << self
        def parse(root)
          messages = root.xpath('./messages/message').collect do |element|
            {:text => element.attributes['text'].value, :kind => element.attributes['kind'].value}
          end if root.xpath('./messages/message')
          GoApiClient::Domain::Project.new(
              {
                  :name => root.attributes['name'].value,
                  :activity => root.attributes['activity'].value,
                  :last_build_status => root.attributes['lastBuildStatus'].value,
                  :last_build_label => root.attributes['lastBuildLabel'].value,
                  :last_build_time => Time.parse(root.attributes['lastBuildTime'].value).utc,
                  :parsed_messages => messages
              })
        end

      end
    end
  end
end
