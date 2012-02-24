require 'nokogiri'
require "go_api_client/version"
require "go_api_client/atom"
require "open-uri"
module GoApiClient
  def self.runs(host)
    doc = Nokogiri::XML(open("http://#{host}/go/api/pipelines/defaultPipeline/stages.xml"))
    feed = GoApiClient::Atom::Feed.new(doc.root).parse!
    pipelines = []
    feed.entries.collect do |entry|
      pipelines = Stage.new(entry, pipelines).fetch
    end
    pipelines
  end

end
