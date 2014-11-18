require 'time'

module GoApiClient
  module Parsers
    class Entry < GoApiClient::Parsers::Helper
      class << self
        def parse(root)
          GoApiClient::Domain::Entry.new(
              {
                  :title => root.xpath('xmlns:title').first.content,
                  :id => root.xpath('xmlns:id').first.content,
                  :updated => Time.parse(root.xpath('xmlns:updated').first.content).utc,
                  :stage_uri => href_from(root.xpath("xmlns:link[@type='application/vnd.go+xml' and @rel='alternate']")),
                  :pipeline_uri => href_from(root.xpath("xmlns:link[@type='application/vnd.go+xml' and  @rel='http://www.thoughtworks-studios.com/ns/relations/go/pipeline']")),
                  :parsed_authors => root.xpath('xmlns:author').collect do |element|
                    GoApiClient::Parsers::Author.parse(element)
                  end,
                  :parsed_categories => root.xpath('xmlns:category').collect do |element|
                    {:term => element.attributes['term'].value, :label => element.attributes['label'].value}
                  end,
              })
        end
      end
    end
  end
end

