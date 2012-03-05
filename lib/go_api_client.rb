require 'nokogiri'
require "open-uri"

require "go_api_client/version"
require "go_api_client/atom"
require 'go_api_client/pipeline.rb'
require 'go_api_client/stage.rb'
require 'go_api_client/job.rb'

module GoApiClient
  def self.runs(host)
    doc = Nokogiri::XML(open("http://#{host}/go/api/pipelines/defaultPipeline/stages.xml"))
    feed = GoApiClient::Atom::Feed.new(doc.root).parse!
    pipelines = {}
    feed.entries.each do |entry|
      Stage.new(entry, pipelines).fetch
    end
    pipelines.values
  end
end
