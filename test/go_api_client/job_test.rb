require "test_helper"

module GoApiClient
  class JobTest < Test::Unit::TestCase
    def setup
      stub_request(:get, "http://localhost:8153/go/api/jobs/1.xml").to_return(:body => file_contents("jobs_1.xml"))
    end

    test "should fetch the job xml and populate itself" do
      link = "http://localhost:8153/go/api/jobs/1.xml"
      job = GoApiClient::Job.from(link)

      assert_equal 'http://localhost:8153/go/api/jobs/1.xml', job.url
      assert_equal 'http://localhost:8153/go/files/defaultPipeline/1/Units/1/Test', job.artifacts_uri
      assert_equal 'http://localhost:8153/go/files/defaultPipeline/1/Units/1/Test/cruise-output/console.log', job.console_log_url
    end

  end
end
