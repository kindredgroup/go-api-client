require 'test_helper'

module GoApiClient
  class StageTest < Test::Unit::TestCase
    test 'should parse stage' do
      stub_request(:get, 'http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml').to_return(:body => file_contents('pipelines_1.xml'))
      stub_request(:get, 'http://localhost:8153/go/api/stages/1.xml').to_return(:body => file_contents('stages_1.xml'))
      stub_request(:get, 'http://localhost:8153/go/api/stages/2.xml').to_return(:body => file_contents('stages_2.xml'))
      stub_request(:get, 'http://localhost:8153/go/api/jobs/1.xml').to_return(:body => file_contents('jobs_1.xml'))
      stub_request(:get, 'http://localhost:8153/go/api/jobs/2.xml').to_return(:body => file_contents('jobs_2.xml'))

      stub_request(:get, 'http://localhost:8153/go/api/pipelines/defaultPipeline/stages.xml').to_return(:body => file_contents('stages.xml'))

      papi = GoApiClient::Client.new.api(:pipeline)
      pipeline = papi.pipeline({:pipeline_name => 'defaultPipeline', :pipeline_id => 1, :eager_parser => [:stage, :job]})
      stages = pipeline.parsed_stages

      assert_equal 2, stages.count

      assert_equal 'http://localhost:8153/go/api/stages/1.xml', stages.first.self_uri
      assert_equal 'http://localhost:8153/go/api/stages/2.xml', stages.last.self_uri

      assert_equal 1, stages.first.counter
      assert_equal 1, stages.last.counter

      assert_equal [Time.parse('2012-02-23T17:16:41+05:30').utc, Time.parse('2012-02-23T17:19:31+05:30').utc], stages.collect(&:updated)
      stages.each do |stage|
        assert_equal 'Failed', stage.result
        assert stage.failed?
        assert false == stage.passed?
      end

      assert_equal 'Units', stages.first.name
      assert_equal 'Acceptance', stages.last.name

      assert_equal 'http://localhost:8153/go/files/defaultPipeline/1/Units/1/Test/cruise-output/console.log', stages.first.parsed_jobs.first.console_log_url
      assert_equal 'http://localhost:8153/go/files/defaultPipeline/1/Acceptance/1/Test/cruise-output/console.log', stages.last.parsed_jobs.first.console_log_url

      assert_equal 'urn:x-go.studios.thoughtworks.com:stage-id:defaultPipeline:1:Units:1', stages.first.id
      assert_equal 'urn:x-go.studios.thoughtworks.com:stage-id:defaultPipeline:1:Acceptance:1', stages.last.id
    end
  end
end
