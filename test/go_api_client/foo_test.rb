require "test_helper"

class FooTest < Test::Unit::TestCase

  def test_case_name
    stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/stages.xml").to_return(:body => file_contents("stages.xml"))
    stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml").to_return(:body => file_contents("pipelines_1.xml"))
    stub_request(:get, "http://localhost:8153/go/api/stages/1.xml").to_return(:body => file_contents("stages_1.xml"))
    stub_request(:get, "http://localhost:8153/go/api/stages/2.xml").to_return(:body => file_contents("stages_2.xml"))
    pipelines = GoApiClient::Atom::Feed.construct
    assert_equal 1, pipelines.count
    stages = pipelines.first.stages
    assert_equal 2, stages.count
    stages.each do |stage|
      assert_equal "oogabooga <twgosaas@gmail.com>", stage.authors.first.name
      assert_equal "Failed", stage.result
    end
    assert_equal "Acceptance", stages.first.name
    assert_equal "Units", stages.last.name
  end


  def file_contents(file_name)
    File.read(File.expand_path("../../fixtures/#{file_name}", __FILE__))
  end


end
