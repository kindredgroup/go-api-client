module GoApiClient
  module Parsers
    class User
      class << self
        def parse(root)
          _, name, email = *root.content.match(/(.*) <(.+?)>/)
          GoApiClient::Domain::User.new(name, email)
        end
      end
    end
  end
end