require "test_helper"

class PipelineTest < Test::Unit::TestCase

  def setup()
    stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml").to_return(:body => file_contents("pipelines_1.xml"))
  end

  def test_fetch_populates_necessary_fields
    link = "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml"
    pipeline = GoApiClient::Pipeline.new(link)
    pipeline.fetch

    assert_equal "1", pipeline.label
    assert_equal ["Update README"], pipeline.commit_messages
  end

  def test_pipeline_instance_identified_by_details_link
    link = "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml"
    pipeline = GoApiClient::Pipeline.new(link)

    assert pipeline.same?(link)
    assert(false == pipeline.same?("http://localhost:8153/go/api"))
  end
end
