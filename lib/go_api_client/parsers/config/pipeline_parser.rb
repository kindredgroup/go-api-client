module GoApiClient
  module Parsers
    module Config
      class Pipeline < GoApiClient::Parsers::Helper
        class << self
          def parse(root)
            template = root.attributes['template'].value if root.attributes['template']
            params = root.xpath('./params/param').collect do |element|
              {:name => element.attributes['name'].value, :value => element.content}
            end if  root.xpath('./params/param')

            env_vars = root.xpath('./environmentvariables/variable').collect do |element|
              secure = true if element.attributes['name']
              value_element = element.xpath('./value').first ? element.xpath('./value') : element.xpath('./encryptedValue')
              {:name => element.attributes['name'].value, :secure => secure, :value => value_element.first.content}
            end if root.xpath('./params/param')

            timer = root.xpath('./timer').first.content if root.xpath('./timer').first
            label_template = root.attributes['labeltemplate'].value if root.attributes['labeltemplate']

            stages = root.xpath('./stage').collect do |element|
              GoApiClient::Parsers::Config::Stage.parse(element)
            end

            GoApiClient::Domain::Config::Pipeline.new(
                {
                    :name => root.attributes['name'].value,
                    :locked => root.attributes['isLocked'] ? root.attributes['isLocked'].value : 'false',
                    :label_template => label_template,
                    :timer => timer,
                    :template => template,
                    :parsed_params => params,
                    :parsed_env_vars => env_vars,
                    :parsed_stages => stages
                })
          end

        end
      end
    end
  end
end
