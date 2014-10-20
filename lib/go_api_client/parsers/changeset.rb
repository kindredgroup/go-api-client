require 'time'

module GoApiClient
  module Parsers
    class Changeset
      class << self
        def parse(root)
          message = root.xpath('./message').first.content if root.xpath('./message').first
          parsed_user = GoApiClient::Parsers::User.parse(root.xpath('./user').first) if root.xpath('./user').first
          files = root.xpath('./file').collect do |element|
            {:name => element.attributes['name'].value, :action => element.attributes['action'].value}
          end if root.xpath('./file').first
          GoApiClient::Domain::Changeset.new(
              {
                  :uri => root.attributes['changesetUri'].value,
                  :checkin_time => Time.parse(root.xpath('./checkinTime').first.content).utc,
                  :revision => root.xpath('./revision').first.content,
                  :message => message,
                  :parsed_user => parsed_user,
                  :files => files
              })
        end
      end
    end
  end
end