module GoApiClient
  module Parsers
    class Author
      class << self
        def parse(root)
          name = root.xpath('xmlns:name').first.content
          email = root.xpath('xmlns:email').first.content rescue nil
          uri = root.xpath('xmlns:uri').first.content rescue nil
          if email.nil? || email.empty?
            if name =~ /(.*) <(.+?)>/
              name, email = $1, $2
            end
          end
          GoApiClient::Domain::Author.new(
              {
                  :name => name,
                  :email => email,
                  :uri => uri
              })
        end
      end
    end
  end
end