require "test_helper"
module GoApiClient
  class ConnectorTest < Test::Unit::TestCase

    def setup
      @options = {:protocol => 'http', :host => 'localhost', :port => 8153, :username => nil, :password => nil, :stop_at => nil, :pipeline_name => 'defaultPipeline'}

      stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml").to_return(:body => file_contents("pipelines_1.xml"))
      stub_request(:get, "http://localhost:8153/go/api/stages/1.xml").to_return(:body => file_contents("stages_1.xml"))
      stub_request(:get, "http://localhost:8153/go/api/stages/2.xml").to_return(:body => file_contents("stages_2.xml"))
      stub_request(:get, "http://localhost:8153/go/api/jobs/1.xml").to_return(:body => file_contents("jobs_1.xml"))
      stub_request(:get, "http://localhost:8153/go/api/jobs/2.xml").to_return(:body => file_contents("jobs_2.xml"))
      stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/stages.xml").to_return(:body => file_contents("stages.xml"))

    end

    test "should be able to connect to the Go server" do
      connector =GoApiClient::Connector.new(@options)
      connector.connect!
      assert_equal 2, connector.stages.count
    end
  end
end
