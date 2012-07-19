require "test_helper"

module GoApiClient
  class BuildingTest < Test::Unit::TestCase

    test "should report that Go is building if atleast 1 project is building" do
      feed = %Q{
              <?xml version="1.0" encoding="utf-8"?>
              <Projects>
                <Project name="defaultPipeline :: RailsTests" activity="Building" lastBuildStatus="Success" lastBuildLabel="4" lastBuildTime="2012-07-19T10:03:04" webUrl="http://go-server.2.project:8153/go/pipelines/defaultPipeline/5/RailsTests/1" />
                <Project name="defaultPipeline :: RailsTests :: Test" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="4" lastBuildTime="2012-07-19T10:03:04" webUrl="http://go-server.2.project:8153/go/tab/build/detail/defaultPipeline/5/RailsTests/1/Test" />
              </Projects>
           }
      stub_request(:get, "http://go-server.2.project:8153/go/cctray.xml").
        to_return(:body => feed)
      assert GoApiClient.build_in_progress?(:host => 'go-server.2.project')
    end

    test "should report that Go is sleeping if all projects are sleeping" do
      feed = %Q{
              <?xml version="1.0" encoding="utf-8"?>
              <Projects>
                <Project name="defaultPipeline :: RailsTests" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="4" lastBuildTime="2012-07-19T10:03:04" webUrl="http://go-server.2.project:8153/go/pipelines/defaultPipeline/5/RailsTests/1" />
                <Project name="defaultPipeline :: RailsTests :: Test" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="4" lastBuildTime="2012-07-19T10:03:04" webUrl="http://go-server.2.project:8153/go/tab/build/detail/defaultPipeline/5/RailsTests/1/Test" />
              </Projects>
           }
      stub_request(:get, "http://go-server.2.project:8153/go/cctray.xml").
        to_return(:body => feed)
      assert_false GoApiClient.build_in_progress?(:host => 'go-server.2.project')
    end

    test "should handle empty feeds" do
      stub_request(:get, "http://go-server.2.project:8153/go/cctray.xml").
        to_return(:body => nil)
      assert_false GoApiClient.build_in_progress?(:host => 'go-server.2.project')
    end
  end
end
