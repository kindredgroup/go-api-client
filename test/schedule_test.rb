require "test_helper"

module GoApiClient
  class ScheduleTest < Test::Unit::TestCase
    test "should schedule a build specified" do
      stub_request(:post, "http://go-server.2.project:8153/go/api/pipelines/defaultPipeline/schedule")
      GoApiClient.schedule_pipeline(:host => 'go-server.2.project')

      assert_requested(:post, "http://go-server.2.project:8153/go/api/pipelines/defaultPipeline/schedule", :body => '')
    end
  end
end