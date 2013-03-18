require "test_helper"

module GoApiClient
  class ArtifactTest < Test::Unit::TestCase
    test "should construct the artifacts from the job xml" do
      stub_request(:get, "http://localhost:8153/go/api/jobs/3.xml").to_return(:body => file_contents("jobs_3.xml"))

      link = "http://localhost:8153/go/api/jobs/3.xml"
      job = GoApiClient::Job.from(link)
      assert_equal 2, job.artifacts.count
      assert_equal "https://ci.snap-ci.com/go/files/Go-SaaS-Rails/898/Dist/1/rpm/tmp.zip", job.artifacts.first.as_zip_file_url
      assert_equal "https://ci.snap-ci.com/go/files/Go-SaaS-Rails/898/Dist/1/rpm/log.zip", job.artifacts.last.as_zip_file_url
    end
  end
end