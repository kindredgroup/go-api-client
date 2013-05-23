require 'nokogiri'

require 'net/http'

require 'go_api_client/version'
require 'go_api_client/helpers'
require 'go_api_client/http_fetcher'

require 'go_api_client/atom'
require 'go_api_client/pipeline'
require 'go_api_client/stage'
require 'go_api_client/job'
require 'go_api_client/artifact'
require 'go_api_client/commit'
require 'go_api_client/user'

module GoApiClient

  # A wrapper that contains the last run information of scraping the go atom feed
  class LastRun
    # A list of pipelines
    # @return [Array<Pipeline>]
    # @see GoApiClient.runs
    attr_reader :pipelines

    # The most recent atom entry when the feed was last fetched
    attr_reader :latest_atom_entry_id

    def initialize(pipelines, latest_atom_entry_id)
      @pipelines            = pipelines
      @latest_atom_entry_id = latest_atom_entry_id
    end
  end

  class << self
    # Connects to the a go server via the "Atom Feed API":http://www.thoughtworks-studios.com/docs/go/current/help/Feeds_API.html
    # and fetches entire the pipeline history for that pipeline. Since this this is a wrapper around an atom feed,
    # it is important to remember the last atom feed entry that was seen in order to prevent crawling the entire atom feed
    # over and over again and slow the process down.
    #
    # @return [LastRun] an object containing a list of all pipelines ordered by their counter along with the last stage that ran in the pipeline
    # @param [Hash] options the connection options
    # @option options [String]  :host ("localhost") Host to connect to.
    # @option options [Ingeger] :port (8153) Port to connect to.
    # @option options [Boolean] :ssl  (false) If connection should be made over ssl.
    # @option options [String]  :username (nil) The username to be used if server or the pipeline requires authorization.
    # @option options [String]  :password (nil) The password to be used if server or the pipeline requires authorization.
    # @option options [String]  :pipeline_name The name of the pipeline that should be fetched.
    # @option options [String]  :latest_atom_entry_id (nil) The id of the last atom feed entry
    def runs(options={})
      options = ({:ssl => false, :host => 'localhost', :port => 8153, :username => nil, :password => nil, :latest_atom_entry_id => nil}).merge(options)

      http_fetcher = GoApiClient::HttpFetcher.new(:username => options[:username], :password => options[:password])

      feed_url = "#{options[:ssl] ? 'https' : 'http'}://#{options[:host]}:#{options[:port]}/go/api/pipelines/#{options[:pipeline_name]}/stages.xml"

      feed = GoApiClient::Atom::Feed.new(feed_url, options[:latest_atom_entry_id])
      feed.fetch!(http_fetcher)

      pipelines = {}
      stages = feed.entries.collect do |entry|
        Stage.from(entry.stage_href, :authors => entry.authors, :pipeline_cache => pipelines, :http_fetcher => http_fetcher)
      end

      pipelines.values.each do |p|
        p.stages = p.stages.sort_by {|s| s.completed_at }
      end

      pipelines = pipelines.values.sort_by {|p| p.counter}
      latest_atom_entry_id = stages.empty? ? options[:latest_atom_entry_id] : feed.entries.first.id
      return LastRun.new(pipelines, latest_atom_entry_id)
    end

    # Answers if a build is in progress. For the list of supported connection options see {GoApiClient.runs #runs}
    # @see .build_finished?
    def build_in_progress?(options={})
      raise ArgumentError("Hostname is mandatory") unless options[:host]
      options = ({:ssl => false, :port => 8153, :username => nil, :password => nil, :pipeline_name => 'defaultPipeline'}).merge(options)
      http_fetcher = GoApiClient::HttpFetcher.new(:username => options[:username], :password => options[:password])
      url = "#{options[:ssl] ? 'https' : 'http'}://#{options[:host]}:#{options[:port]}/go/cctray.xml"
      doc = Nokogiri::XML(http_fetcher.get_response_body(url))
      doc.css("Project[activity='Building'][name^='#{options[:pipeline_name]} ::']").count > 0
    end

    # Answers if a build is in completed. For the list of supported connection options see {GoApiClient.runs #runs}
    # @see .build_in_progress?
    def build_finished?(options)
      !build_in_progress?(options)
    end

    # Schedule a particular pipeline with the latest available materials.
    def schedule_pipeline(options)
      raise ArgumentError("Hostname is mandatory") unless options[:host]
      options = ({:ssl => false, :port => 8153, :username => nil, :password => nil, :pipeline_name => 'defaultPipeline'}).merge(options)

      uri = "#{options[:ssl] ? 'https' : 'http'}://#{options[:host]}:#{options[:port]}/go/api/pipelines/#{options[:pipeline_name]}/schedule"
      GoApiClient::HttpFetcher.new.post(uri)
    end
  end
end
