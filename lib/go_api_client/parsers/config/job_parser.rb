module GoApiClient
  module Parsers
    module Config
      class Job < GoApiClient::Parsers::Helper
        class << self
          def parse(root)
            tasks = root.xpath('./tasks/exec').collect do |element|
              {
                  :command => element.attributes['command'].value,
                  :args => element.xpath('./arg').first ? element.xpath('./arg').collect do |arg_element|
                    arg_element.content
                  end : nil,
                  :runif => element.xpath('./runif').first ? element.xpath('./runif').first.attributes['status'].value : nil
              }
            end if root.xpath('./tasks/exec')

            resources = root.xpath('./resources/resource').collect do |element|
              element.content
            end if root.xpath('./resources/resource')

            tabs = root.xpath('./tabs/tab').collect do |element|
              {:name => element.attributes['name'].value, :path => element.attributes['path'].value}
            end if root.xpath('./tabs/tab')

            artifacts = root.xpath('./artifacts/artifact').collect do |element|
              {:src => element.attributes['src'].value, :dst => element.attributes['dst'] ? element.attributes['dst'].value : nil}
            end if root.xpath('./tabs/tab')

            test_artifacts = root.xpath('./artifacts/test').collect do |element|
              {:src => element.attributes['src'].value, :dst => element.attributes['dst'] ? element.attributes['dst'].value : nil}
            end if root.xpath('./artifacts/test')

            GoApiClient::Domain::Config::Job.new(
                {
                    :name => root.attributes['name'].value,
                    :parsed_tabs => tabs,
                    :parsed_tasks => tasks,
                    :parsed_resources => resources,
                    :parsed_artifacts => artifacts,
                    :parsed_test_artifacts => test_artifacts
                })
          end

        end
      end
    end
  end
end
