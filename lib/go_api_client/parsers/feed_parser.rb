require 'time'

module GoApiClient
  module Parsers
    class Feed < GoApiClient::Parsers::Helper
      class << self
        def parse(root)
          GoApiClient::Domain::Feed.new(
              {
                  :title => root.xpath('xmlns:title').first.content,
                  :id => root.xpath('xmlns:id').first.content,
                  :self_uri => href_from(root.xpath("xmlns:link[@rel='self']")),
                  :next_uri => href_from(root.xpath("xmlns:link[@rel='next']")),
                  :updated => Time.parse(root.xpath('xmlns:updated').first.content).utc,
                  :parsed_authors => root.xpath('xmlns:author').collect do |element|
                    GoApiClient::Parsers::Author.parse(element)
                  end,
                  :parsed_entries => root.xpath('xmlns:entry').collect do |element|
                    GoApiClient::Parsers::Entry.parse(element)
                  end
              })
        end
      end
    end
  end
end

