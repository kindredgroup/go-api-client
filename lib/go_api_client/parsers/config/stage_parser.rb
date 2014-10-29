module GoApiClient
  module Parsers
    module Config
      class Stage < GoApiClient::Parsers::Helper
        class << self
          def parse(root)

            jobs = root.xpath('./jobs/job').collect do |element|
              GoApiClient::Parsers::Config::Job.parse(element)
            end if root.xpath('./jobs/job')

            env_vars = root.xpath('./environmentvariables/variable').collect do |element|
              secure = true if element.attributes['name']
              value_element = element.xpath('./value').first ? element.xpath('./value') : element.xpath('./encryptedValue')
              {:name => element.attributes['name'].value, :secure => secure, :value => value_element.first.content}
            end if root.xpath('./params/param')

            GoApiClient::Domain::Config::Stage.new(
                {
                    :name => root.attributes['name'].value,
                    :clean_working_dir => root.attributes['cleanWorkingDir'] ? root.attributes['cleanWorkingDir'].value : 'false',
                    :fetch_materials => root.attributes['fetchMaterials'] ? root.attributes['fetchMaterials'].value : 'false',
                    :approval =>  root.xpath('./approval').first ? root.xpath('./approval').first.attributes['type'].value : 'automatic',
                    :parsed_jobs => jobs,
                    :parsed_env_vars => env_vars
                })
          end

        end
      end
    end
  end
end
