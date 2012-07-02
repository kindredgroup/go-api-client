require "test_helper"

module GoApiClient
  class BuildingTest < Test::Unit::TestCase
    def setup
      url_to_xml_file_mapping = {
        "api/pipelines/defaultPipeline/1.xml" => "building/pipeline_1.xml",
        "api/pipelines/defaultPipeline/2.xml" => "building/pipeline_2.xml",
        "api/pipelines/defaultPipeline/3.xml" => "building/pipeline_3.xml",
        "api/stages/1.xml" => "building/stages_1.xml",
        "api/stages/2.xml" => "building/stages_2.xml",
        "api/stages/3.xml" => "building/stages_3.xml",
        "api/stages/4.xml" => "building/stages_4.xml",
        "api/jobs/1.xml" => "building/job_1.xml",
        "api/jobs/2.xml" => "building/job_2.xml",
        "api/jobs/3.xml" => "building/job_3.xml",
        "api/jobs/4.xml" => "building/job_4.xml",
        "api/pipelines/defaultPipeline/stages.xml" => "building/stages.xml"
      }

      url_to_xml_file_mapping.each do |url, filename|
        stub_request(:get, "http://go-server.1.project:8153/go/#{url}").
          to_return(:body => file_contents(filename))  
      end
    end

    test "should tell that a build is done if all stages have completed" do
      # defaultPipeline/1.xml
      assert_false GoApiClient.build_in_progress?({:stages => [:units, :functionals], :revision => "a84ffc0e58b7b2ba7d5b15abae70c2d921b835e6", :host => "go-server.1.project"})
    end

    test "should tell that a build is done if a non-terminal stage has failed" do
      # defaultPipeline/2.xml
      assert_false GoApiClient.build_in_progress?({:stages => [:units, :functionals], :revision => "f475d63c2e0f4db5c26e79541278afcb00d63cde", :host => "go-server.1.project"})
    end

    test "should tell that a build is in progress if all non-terminal stage has passed and terminal stage has not completed" do
      # defaultPipeline/3.xml
      assert GoApiClient.build_in_progress?({:stages => [:units, :functionals], :revision => "dc8b3df12b16770dff48cea229559cc0ea40137f", :host => "go-server.1.project"})
    end

  end

  class BuildingTestWithoutRevision < Test::Unit::TestCase
    test "should assume that a build is not running if no revision is passed in" do
      assert false == GoApiClient.build_in_progress?({:stages => [:units, :functionals], :host => "go-server.1.project"})
    end
  end
end
