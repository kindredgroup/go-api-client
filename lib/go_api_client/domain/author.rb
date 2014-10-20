module GoApiClient
  module Domain
    class Author < GoApiClient::Domain::Helper
      attr_accessor :name, :email, :uri

      def initialize(attributes={})
        super(attributes)
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
    end
  end
end
