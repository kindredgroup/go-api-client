require 'nokogiri'
require 'open-uri'
require 'net/http'

require 'go_api_client/version'
require 'go_api_client/atom'
require 'go_api_client/pipeline.rb'
require 'go_api_client/stage.rb'
require 'go_api_client/job.rb'

module GoApiClient
  def self.runs(host, port="8153")
    doc = Nokogiri::XML(open("http://#{host}:#{port}/go/api/pipelines/defaultPipeline/stages.xml"))
    feed = GoApiClient::Atom::Feed.new(doc.root).parse!
    pipelines = {}
    feed.entries.each do |entry|
      Stage.new(entry, pipelines).fetch
    end
    pipelines.values
  end

  # GoApiClient.building?([:units, :functionals], "asdfbaf123123", "go-server.1.project")
  def self.building?(stages, sha, host, port="8153")
    true
  end

  def self.schedule_pipeline(host)
    uri = URI("http://#{host}:8153/go/api/pipelines/defaultPipeline/schedule")
    Net::HTTP.post_form(uri, {})
  end
end
