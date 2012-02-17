require 'ostruct'
module GoApiClient
  class StubHttpFetcher
    # Careful : this will respond to any call with nil
    class HashStruct < OpenStruct
      def [](key)
        self.headers[key]
      end
    end

    module Response
      def invoked!
        @invoked = true
      end

      def invoked?
        !!@invoked
      end
    end

    class StringResponse
      include Response
      def initialize(content, code = 200, headers = {})
        @content = content
        @code = code.to_s
        @headers = headers
      end

      def execute
        HashStruct.new(:body => @content, :code => @code, :headers => @headers)
      end

    end

    class ErrorResponse
      include Response
      def initialize(error)
        @error = error
      end

      def execute
        raise @error
      end
    end

    def get(url)
      if body = interweb[:get][url]
        body.invoked!
        return body.execute
      else
        raise "404 - Could not find #{url}. Available URLs are #{@interweb[:get].keys.inspect}"
      end
    end

    def post(url, params = {})
      if body = interweb[:post][url]
        response = body.execute
        if response.headers == params
          body.invoked!
          return response
        end
      end

      raise "404 - Could not find a url listening to #{url.inspect} that responds to post params #{params.inspect}. Available URLs are #{@interweb[:post].keys.inspect}"
    end

    def invoked?(url, type = :get, params = {})
      if body = interweb[type][url]
        response = body.execute
        if response.headers == params

          body.invoked?
        end
      end
    end

    def register_content(content, url, type = :get, headers = {})
      interweb[type][url] = StringResponse.new(content, 200, headers)
    end

    def register_error(url, type = :get, error)
      interweb[type][url] = ErrorResponse.new(error)
    end

    def interweb
      @interweb ||= {:get => {}, :post => {}}
    end

  end
end

