require "test_helper"

module GoApiClient
  class BuildingTest < Test::Unit::TestCase

    test "should report that Go is building if atleast 1 stage in specified pipeline is building" do
      feed = %Q{
              <?xml version="1.0" encoding="utf-8"?>
              <Projects>
                <Project name="defaultPipeline :: RailsTests" activity="Building" lastBuildStatus="Success" lastBuildLabel="4" lastBuildTime="2012-07-19T10:03:04" webUrl="http://go-server.2.project:8153/go/pipelines/defaultPipeline/5/RailsTests/1" />
                <Project name="defaultPipeline :: SmokeTests" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="4" lastBuildTime="2012-07-19T10:03:04" webUrl="http://go-server.2.project:8153/go/pipelines/defaultPipeline/5/RailsTests/1" />

                <Project name="anotherPipeline :: RailsTests" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="4" lastBuildTime="2012-07-19T10:03:04" webUrl="http://go-server.2.project:8153/go/pipelines/defaultPipeline/5/RailsTests/1" />
                <Project name="anotherPipeline :: SmokeTests" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="4" lastBuildTime="2012-07-19T10:03:04" webUrl="http://go-server.2.project:8153/go/pipelines/defaultPipeline/5/RailsTests/1" />
              </Projects>
           }
      stub_request(:get, "http://go-server.2.project:8153/go/cctray.xml").
        to_return(:body => feed)
      assert       GoApiClient.build_in_progress?(:host => 'go-server.2.project', :pipeline_name => 'defaultPipeline')
      assert_false GoApiClient.build_in_progress?(:host => 'go-server.2.project', :pipeline_name => 'anotherPipeline')
    end

    test "should report that Go is sleeping if all stages in specified pipeline are sleeping" do
      feed = %Q{
              <?xml version="1.0" encoding="utf-8"?>
              <Projects>
                <Project name="defaultPipeline :: RailsTests" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="4" lastBuildTime="2012-07-19T10:03:04" webUrl="http://go-server.2.project:8153/go/pipelines/defaultPipeline/5/RailsTests/1" />
                <Project name="defaultPipeline :: SmokeTests" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="4" lastBuildTime="2012-07-19T10:03:04" webUrl="http://go-server.2.project:8153/go/pipelines/defaultPipeline/5/RailsTests/1" />

                <Project name="anotherPipeline :: RailsTests" activity="Building" lastBuildStatus="Success" lastBuildLabel="4" lastBuildTime="2012-07-19T10:03:04" webUrl="http://go-server.2.project:8153/go/pipelines/defaultPipeline/5/RailsTests/1" />
                <Project name="anotherPipeline :: SmokeTests" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="4" lastBuildTime="2012-07-19T10:03:04" webUrl="http://go-server.2.project:8153/go/pipelines/defaultPipeline/5/RailsTests/1" />
              </Projects>
           }
      stub_request(:get, "http://go-server.2.project:8153/go/cctray.xml").
        to_return(:body => feed)
      assert        GoApiClient.build_finished?(:host => 'go-server.2.project', :pipeline_name => 'defaultPipeline')
      assert_false  GoApiClient.build_finished?(:host => 'go-server.2.project', :pipeline_name => 'anotherPipeline')
    end

    test "should handle empty feeds" do
      stub_request(:get, "http://go-server.2.project:8153/go/cctray.xml").
        to_return(:body => nil)
      assert_false GoApiClient.build_in_progress?(:host => 'go-server.2.project')
    end

  end
end
