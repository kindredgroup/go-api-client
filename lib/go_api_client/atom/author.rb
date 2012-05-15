module GoApiClient
  module Atom
    class Author
      attr_accessor :name, :email, :uri
      def initialize(root, attributes={})
        @root = root
        @name = attributes[:name]
        @email = attributes[:email]
        @uri = attributes[:url]
      end

      def parse!
        self.name     = @root.xpath('xmlns:name').first.content
        self.email    = @root.xpath('xmlns:email').first.content rescue nil
        self.uri      = @root.xpath('xmlns:uri').first.content   rescue nil

        if email.nil? || email.empty?
          if name =~ /(.*) <(.+?)>/
            self.name, self.email = $1, $2
          end
        end

        @root = nil
        self
      end


      def ==(other)
        other && self.class.equal?(other.class) &&
        name == other.name &&
        email == other.email &&
        uri == other.uri
      end

      def hash
        self.class.hash ^ name.hash ^ email.hash ^ uri.hash
      end

      def to_s
        s = "#{name} <#{email}>"
        s << " <#{uri}>" if uri
        s
      end

      def inspect
        "GoApiClient::Atom::Author(#{to_s})"
      end

    end
  end
end
