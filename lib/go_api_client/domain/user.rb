module GoApiClient
  module Domain
    class User
      attr_accessor :name, :email

      def initialize(name, email)
        @name = name
        @email = email
      end

      def ==(other)
        other && self.class.equal?(other.class) &&
            name == other.name &&
            email == other.email
      end

      def hash
        self.class.hash ^ name.hash ^ email.hash
      end

      def to_s
        "#{name} <#{email}>"
      end

      def inspect
        "User(#{to_s})"
      end
    end
  end
end