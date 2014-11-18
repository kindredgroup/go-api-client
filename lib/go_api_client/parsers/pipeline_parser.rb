require 'time'

module GoApiClient
  module Parsers
    class Pipeline < GoApiClient::Parsers::Helper
      class << self
        def parse(root)
          GoApiClient::Domain::Pipeline.new(
              {
                  :name => root.attributes['name'].value,
                  :label => root.attributes['label'].value,
                  :counter => root.attributes['counter'].value.to_i,
                  :self_uri => href_from(root.xpath("./link[@rel='self']")),
                  :inserted_after_uri => href_from(root.xpath("./link[@rel='insertedAfter']")),
                  :id => root.xpath('./id').first.content,
                  :schedule_time => Time.parse(root.xpath('./scheduleTime').first.content).utc,
                  :approved_by => root.xpath('./approvedBy').first.content,
                  :stages => root.xpath('./stages/stage').collect do |element|
                    element.attributes['href'].value
                  end,
                  :parsed_materials => root.xpath('./materials/material').collect do |element|
                    GoApiClient::Parsers::Material.parse(element)
                  end
              })
        end

      end
    end
  end
end
