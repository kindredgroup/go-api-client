require "test_helper"

module GoApiClient
  class StageTest < Test::Unit::TestCase

    test "should parse stage" do
      stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml").to_return(:body => file_contents("pipelines_1.xml"))
      stub_request(:get, "http://localhost:8153/go/api/stages/1.xml").to_return(:body => file_contents("stages_1.xml"))
      stub_request(:get, "http://localhost:8153/go/api/stages/2.xml").to_return(:body => file_contents("stages_2.xml"))
      stub_request(:get, "http://localhost:8153/go/api/jobs/1.xml").to_return(:body => file_contents("jobs_1.xml"))
      stub_request(:get, "http://localhost:8153/go/api/jobs/2.xml").to_return(:body => file_contents("jobs_2.xml"))

      stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/stages.xml").to_return(:body => file_contents("stages.xml"))
      runs = GoApiClient.runs(:host => "localhost", :port => 8153)
      pipelines = runs[:pipelines]
      assert_equal "http://localhost:8153/go/api/stages/2.xml", runs[:latest_atom_entry_id]
      stages = pipelines.first.stages

      assert_equal 1, pipelines.count
      assert_equal 2, stages.count

      assert_equal "http://localhost:8153/go/api/stages/2.xml", stages.first.url
      assert_equal "http://localhost:8153/go/api/stages/1.xml", stages.last.url

      assert_equal 1, stages.first.counter
      assert_equal 1, stages.last.counter

      assert_equal [Time.parse("2012-02-23T17:19:31+05:30").utc, Time.parse("2012-02-23T17:16:41+05:30").utc], stages.collect(&:completed_at)

      assert_equal [Atom::Author.new(nil, :name => 'oogabooga', :email => 'twgosaas@gmail.com')], pipelines.first.authors

      stages.each do |stage|
        assert_equal Atom::Author.new(nil, :name => 'oogabooga', :email => 'twgosaas@gmail.com'), stage.authors.first
        assert_equal "Failed", stage.result
        assert stage.failed?
        assert false == stage.passed?
      end
      assert_equal "Acceptance", stages.first.name
      assert_equal "Units", stages.last.name
      assert_equal ["Update README", "Fixed build"], pipelines.first.commits.collect(&:message)

      assert_equal "http://localhost:8153/go/files/defaultPipeline/1/Acceptance/1/Test/cruise-output/console.log", stages.first.jobs.first.console_log_url
      assert_equal "http://localhost:8153/go/files/defaultPipeline/1/Units/1/Test/cruise-output/console.log", stages.last.jobs.first.console_log_url
      p "Number of stages #{stages.count}"
      assert_equal 'urn:x-go.studios.thoughtworks.com:stage-id:defaultPipeline:1:Acceptance:1', stages.first.identifier
      assert_equal 'urn:x-go.studios.thoughtworks.com:stage-id:defaultPipeline:1:Units:1', stages.last.identifier
    end

    test "empty atom feed should not throw up" do
      stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/stages.xml").to_return(:body => file_contents("stages_empty.xml"))
      runs = GoApiClient.runs(:host => "localhost", :port => 8153)

      assert runs[:pipelines].empty?
    end
  end
end
