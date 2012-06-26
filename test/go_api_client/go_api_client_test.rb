module GoApiClient
  class GoApiClientTest < Test::Unit::TestCase

    def setup
      stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml").to_return(:body => file_contents("pipelines_1.xml"))
      stub_request(:get, "http://localhost:8153/go/api/stages/1.xml").to_return(:body => file_contents("stages_1.xml"))
      stub_request(:get, "http://localhost:8153/go/api/stages/2.xml").to_return(:body => file_contents("stages_2.xml"))
      stub_request(:get, "http://localhost:8153/go/api/jobs/1.xml").to_return(:body => file_contents("jobs_1.xml"))
      stub_request(:get, "http://localhost:8153/go/api/jobs/2.xml").to_return(:body => file_contents("jobs_2.xml"))
      stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/stages.xml").to_return(:body => file_contents("stages.xml"))

      @options = {:protocol => 'http',
                  :host => 'localhost',
                  :port => 8153, :username => nil,
                  :password => nil,
                  :stop_at => nil,
                  :pipeline_name => 'defaultPipeline'}

      @runs = GoApiClient.runs(@options)
    end

    test "Should be able to list all running pipelines and current stage" do
      assert_equal 1, @runs[:pipelines].count
      assert_equal "http://localhost:8153/go/api/stages/2.xml", @runs[:last_stage].url
    end
  end
end

