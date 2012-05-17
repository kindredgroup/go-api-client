require 'nokogiri'

require 'net/http'

require 'go_api_client/version'
require 'go_api_client/helpers'
require 'go_api_client/http_fetcher'

require 'go_api_client/atom'
require 'go_api_client/pipeline'
require 'go_api_client/stage'
require 'go_api_client/job'
require 'go_api_client/commit'
require 'go_api_client/user'


module GoApiClient
  def self.runs(options)
    options = ({:protocol => 'http', :port => 8153, :username => nil, :password => nil, :stop_at => nil, :pipeline_name => 'defaultPipeline'}).merge(options)

    http_fetcher = GoApiClient::HttpFetcher.new(:username => options[:username], :password => options[:password])

    feed_url = "#{options[:protocol]}://#{options[:host]}:#{options[:port]}/go/api/pipelines/#{options[:pipeline_name]}/stages.xml"
    feed = GoApiClient::Atom::Feed.new(feed_url, options[:stop_at])
    feed.fetch!(http_fetcher)

    pipelines = {}
    feed.entries.each do |entry|
      Stage.from(entry.stage_href, :authors => entry.authors, :pipeline_cache => pipelines, :http_fetcher => http_fetcher)
    end
    pipelines.values

  end

  def self.schedule_pipeline(host)
    uri = URI("http://#{host}:8153/go/api/pipelines/defaultPipeline/schedule")
    Net::HTTP.post_form(uri, {})
  end
end

