require 'net/http'
require 'net/https'

module GoApiClient
  class HttpFetcher

    def initialize(options={})
      @username = options[:username]
      @password = options[:password]
    end

    def get(url, options={})
      uri = URI.parse(url)

      password = options[:password] || uri.password || @password
      username = options[:username] || uri.user     || @username
      params   = options[:params]   || {}

      uri.query = URI.encode_www_form(params) if params.any?

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'

      res = http.start do |http|
        req = Net::HTTP::Get.new(uri.request_uri)
        req.basic_auth(username, password) if username || password
        http.request(req)
      end

      case res
      when Net::HTTPSuccess
        return res
      end
      res.error!
    end

    def post(url, options={})
      uri = URI.parse(url)

      password = options[:password] || uri.password || @password
      username = options[:username] || uri.user     || @username
      params   = options[:params]   || {}
      headers  = options[:headers]  || {}

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'

      req = Net::HTTP::Post.new(uri.request_uri)

      headers.each do |header_name, value|
        req[header_name] = value
      end

      req.basic_auth(username, password) if username || password

      req.set_form_data(params)
      res = http.request(req)

      case res
      when Net::HTTPSuccess
        return res
      end
      res.error!
    end

    def get_response_body(url, options={})
      get(url, options).body
    end
  end
end
