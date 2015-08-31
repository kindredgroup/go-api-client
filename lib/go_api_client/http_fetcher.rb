require 'net/http'
require 'net/https'
require 'json'

module GoApiClient
  class HttpFetcher

    class ConnectionError <StandardError
    end

    class HttpError < ConnectionError
      attr_reader :http_code

      def initialize(msg, http_code)
        super(msg)
        @http_code = http_code
      end
    end

    NET_HTTP_EXCEPTIONS = [
        EOFError,
        Errno::ECONNABORTED,
        Errno::ECONNREFUSED,
        Errno::ECONNRESET,
        Errno::ECONNRESET, EOFError,
        Errno::EINVAL,
        Errno::ETIMEDOUT,
        Net::HTTPBadResponse,
        Net::HTTPClientError,
        Net::HTTPError,
        Net::HTTPFatalError,
        Net::HTTPHeaderSyntaxError,
        Net::HTTPRetriableError,
        Net::HTTPServerException,
        Net::ProtocolError,
        SocketError,
        Timeout::Error,
    ]

    NET_HTTP_EXCEPTIONS << OpenSSL::SSL::SSLError if defined?(OpenSSL)

    attr_accessor :response

    def initialize(options={})
      @username = options[:username]
      @password = options[:password]
      @ssl_verify_mode = options[:ssl_verify_mode]
      @read_timeout = options[:read_timeout]
    end

    %w(get post delete patch).each do |meth|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      def #{meth}!(url, options={})
        response_body = #{meth}(url, options).body
        if failure?
          message = "Could not fetch url \#{url}."
          GoApiClient.logger.error("\#{message} The response returned status \#{status} with body `\#{response_body}'")
          raise HttpError.new(message, status)
        end
        return response_body
      rescue *NET_HTTP_EXCEPTIONS => e
        message = "Could not connect to url \#{url}."
        GoApiClient.logger.error("\#{message}. The error was \#{e.message}")
        GoApiClient.logger.error(e.backtrace.collect {|l| "    \#{l}"}.join("\n"))
        raise ConnectionError.new(e)
      end

      def #{meth}(url, options={}, limit=10)
        call('#{meth}', url, options, limit)
      end
      RUBY_EVAL
    end

    def status
      @response.code.to_i
    end

    def success?
      (200..299).include?(status)
    end

    def failure?
      !success?
    end

    private
    def call(method_name, url, options, limit)
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0
      uri = URI.parse(url)

      password = options[:password] || uri.password || @password
      username = options[:username] || uri.user || @username
      ssl_verify_mode = options[:ssl_verify_mode] || @ssl_verify_mode
      read_timeout = options[:read_timeout] || @read_timeout || 60
      params = options[:params] || {}
      headers = options[:headers] || {}

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      http.verify_mode = ssl_verify_mode == 0 ? OpenSSL::SSL::VERIFY_NONE : OpenSSL::SSL::VERIFY_PEER
      http.read_timeout = read_timeout

      class_name = method_name.slice(0, 1).capitalize + method_name.slice(1..-1)
      method_class = "Net::HTTP::#{class_name}".split('::').inject(Object) { |n, c| n.const_get c }
      req = method_class.new(uri.request_uri)

      headers.each do |header_name, value|
        req[header_name] = value
      end

      req.basic_auth(username, password) if username || password
      if headers['Content-Type'] && headers['Content-Type'] == 'application/json'
        req.body = params.to_json
      else
        req.set_form_data(params)
      end

      response = http.request(req)
      case response
        when Net::HTTPRedirection then
          @response = self.send(method_name.to_sym, response['location'], options, limit - 1)
        else
         @response = response
      end

      @response
    end
  end
end
