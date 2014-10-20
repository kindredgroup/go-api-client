require 'test_helper'

module GoApiClient
  class ArtifactTest < Test::Unit::TestCase
    test 'should construct the artifacts from the job xml' do
      link = 'http://localhost:8153/go/api/jobs/3.xml'
      stub_request(:get, link).to_return(:body => file_contents('jobs_3.xml'))

      job = GoApiClient::Client.new.api(:job).job({:job_uri => link})
      assert_equal 2, job.parsed_artifacts.count
      assert_equal 'https://ci.snap-ci.com/go/files/Go-SaaS-Rails/898/Dist/1/rpm/tmp.zip', job.parsed_artifacts.first.as_zip_file_url
      assert_equal 'https://ci.snap-ci.com/go/files/Go-SaaS-Rails/898/Dist/1/rpm/log.zip', job.parsed_artifacts.last.as_zip_file_url
    end
  end
end