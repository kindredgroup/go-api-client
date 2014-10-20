module GoApiClient
  module Domain
    class InternalCache
      attr_accessor :uri, :options

      def initialize(uri, options = {})
        @uri = uri
        @options = options
      end

      def ==(other)
        other && self.class.equal?(other.class) &&
            @uri == other.uri &&
            @options[:eager_parser] == other.options[:eager_parser]
      end

      def hash
        @uri.hash ^ @options[:eager_parser].hash
      end

      def eql?(other)
        other && self.class.equal?(other.class) &&
            @uri.eql?(other.uri) &&
            @options[:eager_parser].eql?(other.options[:eager_parser])
      end
    end
  end
end
