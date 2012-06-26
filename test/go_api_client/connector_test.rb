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
      @connector =GoApiClient::Connector.new(@options)
      @connector.connect!

    end

    test "should be able to connect to the Go server and list stages" do
      assert_equal 2, @connector.stages.count

      first_stage =  @connector.stages[0]
      assert_equal "urn:x-go.studios.thoughtworks.com:stage-id:defaultPipeline:1:Acceptance:1",first_stage.identifier
      assert_equal "http://localhost:8153/go/api/stages/2.xml",first_stage.url
      assert_equal 1,first_stage.jobs.count
      assert_equal 1,first_stage.authors.count

      second_stage =  @connector.stages[1]
      assert_equal "urn:x-go.studios.thoughtworks.com:stage-id:defaultPipeline:1:Units:1",second_stage.identifier
      assert_equal "http://localhost:8153/go/api/stages/1.xml",second_stage.url
      assert_equal 1,second_stage.jobs.count
      assert_equal 1,second_stage.authors.count

    end
  end
end
