require "test_helper"

module GoApiClient
  class PipelineTest < Test::Unit::TestCase

    def setup
      stub_request(:get, "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml").to_return(:body => file_contents("pipelines_1.xml"))
    end

    test "should fetch the pipeline xml and populate itself" do
      link = "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml"
      pipeline = GoApiClient::Pipeline.new(link)
      pipeline.fetch

      assert_equal "1", pipeline.label
      assert_equal ["Update README", "Fixed build"], pipeline.commits.collect(&:message)
    end

    test "should return a list of authors from the first stage" do
      link = "http://localhost:8153/go/api/pipelines/defaultPipeline/1.xml"
      pipeline = GoApiClient::Pipeline.new(link).fetch
      author_foo = Atom::Author.new(nil, :name => 'foo', :email => 'foo@example.com', :uri => 'http://foo.example.com')
      author_bar = Atom::Author.new(nil, :name => 'bar', :email => 'bar@example.com', :uri => 'http://bar.example.com')

      pipeline.stages << OpenStruct.new(:authors => [author_foo, author_bar])
      assert_equal [author_foo, author_bar], pipeline.authors
    end

  end
end
