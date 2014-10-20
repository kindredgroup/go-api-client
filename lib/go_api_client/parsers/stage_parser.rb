require 'time'

module GoApiClient
  module Parsers
    class Stage < GoApiClient::Parsers::Helper
      class << self
        def parse(root)
          GoApiClient::Domain::Stage.new(
              {
                  :name => root.attributes['name'].value,
                  :counter => root.attributes['counter'].value.to_i,
                  :id => root.xpath('./id').first.content,
                  :self_uri => href_from(root.xpath("./link[@rel='self']")),
                  :result => root.xpath('./result').first.content,
                  :updated => Time.parse(root.xpath('./updated').first.content).utc,
                  :state => root.xpath('./state').first.content,
                  :approved_by => root.xpath('./approvedBy').first.content,
                  :jobs => root.xpath('./jobs/job').collect do |element|
                    element.attributes['href'].value
                  end,
                  :pipeline_name => root.xpath('./pipeline').first.attributes['name'].value,
                  :pipeline_counter => root.xpath('./pipeline').first.attributes['counter'].value,
                  :pipeline_label => root.xpath('./pipeline').first.attributes['label'].value,
                  :pipeline_uri => root.xpath('./pipeline').first.attributes['href'].value
              })
        end
      end
    end
  end
end

