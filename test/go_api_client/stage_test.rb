require "test_helper"

class StageTest < Test::Unit::TestCase

  def setup()
    stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/stages.xml").to_return(:body => file_contents("stages.xml"))
    stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml").to_return(:body => file_contents("pipelines_1.xml"))
    stub_request(:get, "http://localhost:8153/go/api/stages/1.xml").to_return(:body => file_contents("stages_1.xml"))
    stub_request(:get, "http://localhost:8153/go/api/stages/2.xml").to_return(:body => file_contents("stages_2.xml"))
    stub_request(:get, "http://localhost:8153/go/api/jobs/1.xml").to_return(:body => file_contents("jobs_1.xml"))
    stub_request(:get, "http://localhost:8153/go/api/jobs/2.xml").to_return(:body => file_contents("jobs_2.xml"))
  end

  def test_stage
    pipelines = GoApiClient.runs("localhost:8153")
    stages = pipelines.first.stages
    
    assert_equal 1, pipelines.count
    assert_equal 2, stages.count
    assert_equal "oogabooga <twgosaas@gmail.com>", pipelines.first.authors
    stages.each do |stage|
      assert_equal "oogabooga <twgosaas@gmail.com>", stage.authors.first.name
      assert_equal "Failed", stage.result
    end
    assert_equal "Acceptance", stages.first.name
    assert_equal "Units", stages.last.name
    assert_equal ["Update README"], pipelines.first.commit_messages

    assert_equal "http://localhost:8153/go/files/defaultPipeline/1/Acceptance/1/Test/cruise-output/console.log", stages.first.jobs.first.console_log_url
    assert_equal "http://localhost:8153/go/files/defaultPipeline/1/Units/1/Test/cruise-output/console.log", stages.last.jobs.first.console_log_url
  end
end
